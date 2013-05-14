def write_project( name, list, overwrite = false )
  # fail if no name
  return false if name == ''

  # Read exisiting file if any into hash. Update only if display key
  # does not exist. Rewrite file from hash.

  # filepath
  filepath = "#{ ENV[ 'APP_ROOT' ] }/db/projects/#{ name }.yaml"

  # fail if no overwrite and exists
  return false if File.exists?( filepath ) && !overwrite

  # if exists?
  if File.exists?( filepath )
    records = YAML::load( File.open( filepath ) )[ 'list' ]
    record_display = records.map{ |r| r[ 'display' ] }
  else
    records = []
    record_display = []
  end

  # remove if only in record_display
  records.delete_if { |record| !list.include?( record[ 'display' ] ) }

  # create new records so the list manages the sort
  new_records = []

  # add if new record_display
  list.each do |item|
    unless record_display.include?( item )
      uuid = SecureRandom.hex( 10 ) # list_item[/\(.*?\)/]
      name = item.split( ' (' )[ 0 ]
      display = "#{ name } (#{ uuid })"
      new_record = {
        'display' => display,
        'name' => name,
        'uuid' => uuid
      }
      # package? expand blocks
      if name.split( ' ' )[ 0 ] == 'b'
        new_record[ 'name' ] = new_record[ 'name' ][ 2..-1 ]
      else
        new_record[ 'blocks' ] = package_blocks( name )
      end
      new_records << new_record
    else
      new_records << records.select{ |r| r[ 'display' ] == item }[ 0 ]
    end
  end

  # write
  File.open( filepath, 'w') { |f| f.write( { 'list' => new_records }.to_yaml ) }
end


def package_blocks( name )
  package = get_first_package( 'name', name )
  blocks = package[ 'blocks' ]
  blocks.each do |block|
    unless block.has_key?( 'uuid' )
      block[ 'uuid' ] = SecureRandom.hex( 10 )
    end
  end
  return blocks
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
