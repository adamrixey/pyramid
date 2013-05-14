class Pyravid < Sinatra::Application

  get '/' do
    @packages = get_packages
    @blocks = get_blocks
    erb :project_new
  end

  post '/' do
    name = ActiveSupport::Inflector.parameterize( params[ :name ] )
    list = { 'list' => params[ :list ].split( "\r\n" ) }
    if write_project( name, list )
      flash[ :success ] = 'Project update successful.'
      redirect "/projects/#{ name }"
    else
      flash.now[ :error ] = 'Project creation failed.'
      @packages = get_packages
      @blocks = get_blocks
      erb :project_new
    end
  end

  get '/blocks/:name/?' do
    @block = get_first_block( 'name', params[ :name ] )
    erb :block_show
  end

  get '/packages/:name/?' do
    @package = get_first_package( 'name', params[ :name ] )
    erb :package_show
  end

  get '/projects/?' do
    @projects = get_projects
    erb :project_index
  end

  get '/projects/:name/?' do
    @packages = get_packages
    @blocks = get_blocks
    @project = get_first_project( 'name', params[ :name ] )
    erb :project_edit
  end

  get '/projects/:name/blocks.csv' do
    content_type 'text/plain'
    project = get_first_project( 'name', params[ :name ] )
    project_block_display( project[ 'list' ] )
  end

end
