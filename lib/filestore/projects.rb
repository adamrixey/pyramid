def write_project( name, list )
  return false if name == ''
  filepath =
    "#{ ENV[ 'APP_ROOT' ] }/db/projects/#{ name }.yaml"
  File.open( filepath, 'w') { |f| f.write( list.to_yaml ) }
end

def get_projects

  projects = []

  # get files
  filepaths = Dir[ "#{ ENV[ 'APP_ROOT' ] }/db/projects/*.yaml" ]

  # read files and check for missing uuid
  filepaths.each do |filepath|
    # read file
    record = YAML::load( File.open( filepath ) )
    # add base filename as blockname
    record[ 'name' ] = File.basename( filepath, '.*' )
    # add to blocks
    projects << record
  end

  return projects

end


def get_first_project( key, value )
  projects = get_projects
  projects_set = projects.select { |p| p[ key ] == value }
  return projects_set[ 0 ]
end
