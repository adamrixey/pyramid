def project_block_display( project_list )
  # define
  results = []
  top = 0

  # each list item
  project_list.each do |item|
    # args
    args = item.split( ' ' )

    # block or package?
    if args[ 0 ].downcase == 'b'
      # block
      bld = block_line_display( args[ 1 ], 0, top, 0 )
      results << bld[ :line ]
      top += bld[ :height ]
    else
      # package
      pld = package_lines_display( args[ 0 ], top )
      results << pld[ :lines ]
      top += pld[ :height ]
    end
  end
  return results.flatten.join( "\n" )
end


def package_lines_display( package_name, package_y )
  # define
  max_height = 0
  lines = []
  package = get_first_package( 'name', package_name )

  # each block
  package[ 'blocks' ].each do |block|
    # get block line with coordinates plus package_y
    bld = block_line_display( block[ 'name' ], block[ 'x' ],
      block[ 'y' ] + package_y, block[ 'z' ] )
    # add lines
    lines << bld[ :line ]
    # update max_height if larger
    if max_height < bld[ :height ]
      max_height = bld[ :height ]
    end
  end
  return { lines: lines , height: max_height }
end


def block_line_display( block_name, block_x, block_y, block_z )
  # constants
  attribute_height = 40
  bottom_margin = 20

  # define
  results = []
  block = get_first_block( 'name', block_name )

  # height calculation
  height = ( block[ 'attributes' ].count * attribute_height ) +
    bottom_margin

  # build results
  results << block[ 'uuid' ]
  results << block[ 'name' ]
  results << block[ 'desc' ]
  results << block_x # x coordinates
  results << block_y # y coordinates
  results << block_z # z coordinates
  block[ 'attributes' ].each do |attrib|
    results << "#{ attrib[ 'pretag' ] }-connector"
    results << attrib[ 'connector' ]
    results <<"#{ attrib[ 'pretag' ] }-label"
    results << attrib[ 'label' ]
    results << "#{ attrib[ 'pretag' ] }-signal"
    results << attrib[ 'signal' ]
  end

  # return
  { line: results.join( ',' ), height: height }
end

