def get_blocks

  blocks = []

  # get files
  filepaths = Dir[ "#{ ENV[ 'APP_ROOT' ] }/db/blocks/*.yaml" ]

  # read files and check for missing uuid
  filepaths.each do |filepath|
    # read file
    record = YAML::load( File.open( filepath ) )
    # add base filename as blockname
    record[ 'name' ] = File.basename( filepath, '.*' )
    # add to blocks
    blocks << record
  end

  return blocks

end


def get_first_block( key, value )
  blocks = get_blocks
  blocks_set = blocks.select { |b| b[ key ] == value }
  return blocks_set[ 0 ]
end
