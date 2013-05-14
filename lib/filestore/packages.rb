def get_packages

  packages = []

  # get files
  filepaths = Dir[ "#{ ENV[ 'APP_ROOT' ] }/db/packages/*.yaml" ]

  # read files and check for missing uuid
  filepaths.each do |filepath|
    # read file
    record = YAML::load( File.open( filepath ) )
    # add base filename as blockname
    record[ 'name' ] = File.basename( filepath, '.*' )
    # add to blocks
    packages << record
  end

  return packages

end


def get_first_package( key, value )
  packages = get_packages
  packages_set = packages.select { |p| p[ key ] == value }
  return packages_set[ 0 ]
end
