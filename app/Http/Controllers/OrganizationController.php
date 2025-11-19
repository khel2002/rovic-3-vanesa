<?php

namespace App\Http\Controllers;

use App\Models\Organization;
use Illuminate\Http\Request;
use App\Models\User;
use App\Models\UserProfile;

class OrganizationController extends Controller
{
    public function index()
    {
        // Get all organizations with members count and adviser relation
        $organizations = Organization::with(['adviserUser.profile', 'members'])
                                     ->withCount('members')
                                     ->get();

        // Get all advisers from users table with their profile
        $advisers = User::where('account_role', 'Faculty_Adviser')
                        ->with('profile')
                        ->get();
        // Get student org officer
        $officers = User::where('account_role', 'Student_Organization')
                    ->whereHas('profile')
                    ->with('profile')
                    ->get();

        return view('admin.organizations.organizations', compact('organizations','advisers','officers'));
    }


    public function store(Request $request)
    {
        // Validate input
        $validated = $request->validate([
            'organization_name' => 'required|string|max:255',
            'organization_type' => 'required|string|max:255',
            'adviser_name' => 'nullable|integer|exists:users,user_id',
            'description' => 'nullable|string',
            'officer_id' => 'nullable|integer|exists:users,user_id', // Optional dropdown
            'officer_name' => 'nullable|string',
            'contact_email' => 'nullable|email',       // store in organizations table
            'contact_number' => 'nullable|string|max:20', // store in organizations table
        ]);

        // Assign current logged-in user as creator
        $validated['user_id'] = auth()->id();

        // Create the organization (with email/contact stored here)
        $organization = Organization::create($validated);

        // Only create officer record if a user was selected
        if (!empty($validated['officer_id'])) {
            $organization->officers()->create([
                'user_id' => $validated['officer_id'],
                'role' => 'Officer',
                'officer_name' => $validated['officer_name'] ?? 'Officer 1', // optional
            ]);
        }

        return redirect()->back()->with('success', 'Organization added successfully!');
    }

    public function show($organization_id)
    {
        $org = Organization::with([
        'adviserUser.profile',           // adviser
        'officerUser.profile'            // officer (from users -> user_profiles)
        ])->withCount('members')
      ->findOrFail($organization_id);

        return response()->json([
            'organization_name' => $organization->organization_name,
            'organization_type' => $organization->organization_type,
            'description'       => $organization->description,
            'members_count'     => $organization->members_count,
            'adviser'           => optional($organization->adviserUser->profile)->first_name . ' ' . optional($organization->adviserUser->profile)->last_name,
            'status'            => $organization->status,
            'created_at'        => $organization->created_at->format('F d, Y'),
            'logo'              => $organization->logo,
            // Officer fields from user_profiles
            'officer_name'      => $officerUser ? optional($officerUser->profile)->first_name . ' ' . optional($officerUser->profile)->last_name : null,
            'contact_number'    => $officerUser?->profile?->contact_number ?? null,
            'contact_email'     => $officerUser?->profile?->contact_email ?? null,
        ]);
    }



    public function destroy($organization_id)
    {
      // dd('Route works. ID = '.$organization_id);
        $org = Organization::find($organization_id);
        if ($org) {
            $org->delete();
            return response()->json(['success' => true, 'message' => 'Organization deleted successfully']);
        }
        return response()->json(['success' => false, 'message' => 'Organization not found']);
    }


}
