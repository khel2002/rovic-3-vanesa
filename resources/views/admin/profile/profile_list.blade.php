@php
  $container = 'container-xxl';
  $containerNav = 'container-xxl';
@endphp

@extends('layouts/contentNavbarLayout')
@section('title', 'User Profile List')
@section('content')
<!-- Hoverable Table rows -->
<div class="d-flex justify-content-start align-items-center mb-3">
  <div class="position-relative">
    <i class="mdi mdi-magnify position-absolute" style="top: 50%; left: 10px; transform: translateY(-50%); color: #6c757d;"></i>
    <input type="text" id="profileSearch" class="form-control ps-5 border-0 shadow-none" placeholder="Search profiles..." style="background: transparent;">
  </div>
</div>
<div class="card">
  <div class="card-header d-flex justify-content-between align-items-center">
    <h5 class="mb-0 text-dark">USER PROFILES</h5>
      <!-- Add Button -->
      <a href="{{ route('profiles.create') }}" class="btn btn-primary btn-lg ms-2">
        <i class="bx bx-plus"></i> Add New Profile
      </a>
  </div>
  <div class="table-responsive text-nowrap">
    <table class="table table-hover text-center">
      <thead>
        <tr>
          <th>Last Name</th>
          <th>First Name</th>
          <th>Email</th>
          <th>Type</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody class="table-border-bottom-0">
          @forelse ($user_profiles as $user_profile)
          <tr>
            <td>sample Lname</td>
            <td>sample Fname</td>
            <td>Sample Email</td>
            <td>Employee/Student</td>
            <td>
                <a href="" class="btn btn-sm btn-info">
                    <i class="bx bx-edit"></i>View
                </a>
                <a href="" class="btn btn-sm btn-warning">
                    <i class="bx bx-edit"></i> Edit
                </a>
                <button type="button" class="btn btn-danger btn-sm"
                      data-bs-target="#confirmDeleteModal" data-user-id=""
                      data-username="">
                      <i class="bx bx-trash"></i> Delete
                </button>
            </td>
          </tr>
          @empty
          <tr>
            <td colspan="6" class="text-center text-muted">No Profiles found.</td>
          </tr>
          @endforelse
      </tbody>
    </table>
  </div>
</div>
<!--/ Hoverable Table rows -->
@endsection
