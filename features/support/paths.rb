module NavigationHelpers    
  
  def path_to(page_name)
    case page_name    
    when /the\s+homepage/
      root_path
    when /the sign-in page/
      new_user_session_path
    when /the new case page/
      new_case_path
    when /details page of "(.*?)"/
      m = page_name.scan(/details page of "(.*?)"/)
      case_path(Case.find_by_title(m[0].first))
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        path_method = path_components.push('path').join('_')
        self.send(path_method)

      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
