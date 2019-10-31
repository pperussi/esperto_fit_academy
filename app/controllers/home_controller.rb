class HomeController < ApplicationController

  def index
    logger.tagged 'Home' do
      logger.info 'Pagina inicial acessada' 
    end
  end
end
