## 0.0.1

* TODO: Describe initial release.

## 2025-03-22

### UI Component Updates
* Replaced TextFieldAppi with DropDownFieldAppi in the home screen
* Implemented dropdown functionality with searchable capabilities
* Added sample items list for demonstration
* Configured proper styling and callbacks for the dropdown
* Added proper error handling and focus management
* Created new SearchableDropdownAppi widget with enhanced search functionality
  * Integrated dedicated search box within the dropdown
  * Added customizable empty state widget
  * Implemented keyboard navigation support
  * Added auto-focusing on the search field when dropdown opens

### Bug Fixes
* Fixed an issue in DropDownFieldAppi where onChanged callback was not consistently triggered when clicking on dropdown items
  * Changed item selection from onTapDown to onTap to ensure the callback is properly triggered on complete tap events
  * This resolves the intermittent behavior where dropdown would close but the selection callback wouldn't fire
* Fixed lint issues in SearchableDropdownAppi implementation
  * Removed unused LayerLink field
  * Improved focus handling and memory management
  * Optimized dropdown positioning logic
