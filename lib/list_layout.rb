# Look at each project list item. If block, add to results and top. If
# package, loop through package blocks and add to results and top.

def list_layout( project_list )
  # define results and top
  results = []
  top = 0

  # each project list item
  project_list.each do |item|
    if item[ 'display' ][ 0 ] == 'b'
      # item is block
      bcl = block_csv_line( item[ 'name' ], item[ 'uuid' ], 0, top, 0 )
      results << bcl[ :line ]
      top += bcl[ :height ]
    else
      # item is package of blocks
      max_height = 0
      item[ 'blocks' ].each do |bk|
        bcl = block_csv_line( bk[ 'name' ], bk[ 'uuid' ], bk[ 'x' ],
          bk[ 'y'] + top, bk[ 'z' ] )
        results << bcl[ :line ]
        if max_height < bcl[ :height ]
          max_height = bcl[ :height ]
        end
      end
      top += max_height
    end
  end
  return results.join( "\n" )
end


def block_csv_line( block_name, uuid, block_x, block_y, block_z )
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
  results << uuid
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

