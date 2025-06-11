# AI Guide for PowerShell Module Development

## Lessons Learned from SPSImmyBot Module Development

### 1. API Response Structure Discovery
**Problem**: Assumed API response had `items` property when it actually used `results`.
**Lesson**: Always verify actual API response structure before writing code. Don't assume standard pagination patterns.
**Best Practice**: 
- Test API endpoints manually first
- Use `Write-Verbose` to log actual response structure
- Check API documentation or use browser dev tools to see real responses

### 2. Pagination vs. Complete Results
**Problem**: Implemented complex pagination logic when API returns all results in one call.
**Lesson**: Some APIs return complete datasets rather than paginated results. Don't over-engineer.
**Best Practice**:
- Test with small and large datasets to understand API behavior
- Keep `-First` parameter for client-side limiting even if API doesn't paginate
- Document actual API behavior in function comments

### 3. Function Naming Consistency
**Problem**: Mixed case in function calls (`Invoke-ImmyAPI` vs `Invoke-ImmyApi`).
**Lesson**: PowerShell is case-insensitive but consistency matters for readability and debugging.
**Best Practice**:
- Use consistent PascalCase for all function names
- Search and replace to fix inconsistencies across entire codebase
- Use `list_code_usages` tool to find all references when renaming

### 4. Test File Management
**Problem**: Overwrote test files and created syntax errors.
**Lesson**: Be careful with file edits, especially with complex test files.
**Best Practice**:
- Read files before editing to understand current state
- Make smaller, targeted edits rather than large replacements
- Keep tests simple and focused on essential functionality
- Don't get hung up on comprehensive test coverage during initial development

### 5. Module Configuration Persistence
**Problem**: Module configuration wasn't persisting between sessions.
**Lesson**: PowerShell module variables are session-scoped unless explicitly saved.
**Best Practice**:
- Use configuration files or registry for persistent settings
- Provide clear setup instructions for module configuration
- Test module import/export behavior in fresh PowerShell sessions

### 6. Parameter Design Philosophy
**Problem**: Removed useful parameters (like `-First`) in pursuit of "API purity."
**Lesson**: User experience trumps API design purity. Keep useful parameters even if they're client-side.
**Best Practice**:
- Prioritize user convenience over technical purity
- Client-side filtering/limiting is acceptable and often preferred
- Document whether parameters are server-side or client-side

### 7. Error Handling Strategy
**Problem**: Inconsistent error handling and verbose logging.
**Lesson**: Good error handling and logging are crucial for debugging API issues.
**Best Practice**:
- Use `Write-Verbose` extensively for troubleshooting
- Include endpoint URLs and parameters in verbose output
- Provide clear error messages that help users understand what went wrong
- Test error conditions (network failures, invalid parameters, etc.)

### 8. Module Structure Cleanup
**Problem**: Legacy functions and naming conventions cluttered the module.
**Lesson**: Technical debt accumulates quickly. Clean up systematically.
**Best Practice**:
- Remove deprecated functions completely rather than just hiding them
- Update all references when renaming functions
- Use consistent naming conventions throughout the module
- Document backward compatibility breaks clearly

### 9. Live Testing vs. Mocked Testing
**Problem**: Tests passed with mocks but failed with live API.
**Lesson**: Mock tests are useful but don't replace live API testing.
**Best Practice**:
- Test with live APIs early and often
- Keep mock tests simple and focused on structure validation
- Use configuration switching to test against different environments
- Document live testing setup requirements

### 10. Documentation Synchronization
**Problem**: Help documentation didn't match actual function parameters.
**Lesson**: Documentation easily gets out of sync with code changes.
**Best Practice**:
- Update help documentation immediately when changing parameters
- Include practical examples that users can copy-paste
- Document parameter behavior clearly (server-side vs client-side)
- Use consistent formatting across all function documentation

### 11. Syntax Error Prevention
**Problem**: Missing line breaks in code causing concatenation and syntax errors.
**Lesson**: Always verify line breaks are preserved when editing code, especially with long parameter lists.
**Best Practice**:
- Use `get_errors` tool after making file edits to catch syntax issues immediately
- Be extra careful with multi-line statements and parameter assignments
- Test functions after each edit to catch issues early

### 12. Endpoint URL Construction
**Problem**: Variable interpolation not working in endpoint URLs due to missing ComputerId in path.
**Lesson**: When debugging API calls, check the actual endpoint construction in verbose output.
**Best Practice**:
- Use verbose logging to show the final constructed endpoint
- Test endpoint construction with simple values first
- Validate that all variables are properly interpolated in URLs

### 13. Parameter Default Values in APIs
**Problem**: Boolean parameters need explicit handling for API query strings.
**Lesson**: PowerShell boolean handling doesn't always translate directly to API expectations.
**Best Practice**:
- Convert booleans to lowercase strings for API calls: `$boolean.ToString().ToLower()`
- Be explicit about default parameter values in function help
- Test all parameter combinations, especially boolean switches

## PowerShell Module Development Checklist

### Before Starting
- [ ] Understand the actual API behavior (not just documentation)
- [ ] Test API endpoints manually with tools like Postman or curl
- [ ] Verify authentication and configuration requirements

### During Development
- [ ] Use consistent function naming conventions
- [ ] Add extensive `Write-Verbose` logging for debugging
- [ ] Test with both small and large datasets
- [ ] Keep user experience as the primary concern
- [ ] Update documentation immediately when changing code

### Before Finalizing
- [ ] Test module import/export in fresh PowerShell session
- [ ] Verify all function names are consistent throughout codebase
- [ ] Test with live API, not just mocks
- [ ] Ensure configuration persists between sessions
- [ ] Clean up deprecated functions and references

### Testing Strategy
- [ ] Start with simple, essential tests
- [ ] Don't over-engineer test coverage initially
- [ ] Test both success and failure scenarios
- [ ] Validate actual API response structures
- [ ] Test parameter combinations that users will actually use

## Common PowerShell Gotchas

1. **Case Sensitivity**: PowerShell is case-insensitive but consistency helps debugging
2. **Variable Scope**: Module variables don't persist unless explicitly saved
3. **Parameter Binding**: `$PSBoundParameters.ContainsKey()` is safer than checking for `$null`
4. **Array Handling**: Empty arrays can cause issues; always test for count
5. **Error Propagation**: Use `throw` to propagate errors up the call stack

## Tools That Help

1. **`semantic_search`**: Find code patterns across the entire codebase
2. **`list_code_usages`**: Find all references when renaming functions
3. **`get_errors`**: Validate syntax after making changes
4. **`run_in_terminal`**: Test live functionality quickly
5. **`read_file`**: Always check current state before editing

Remember: It's better to have a working, slightly imperfect module than a perfect module that doesn't work!
