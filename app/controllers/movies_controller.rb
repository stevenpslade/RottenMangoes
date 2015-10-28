    class MoviesController < ApplicationController

      def index

        @movies = Movie.all

        # if params[:title] != nil
        #   @movies = @movies.where("title like ?", "%#{params[:title]}%")
        # end
        
        # if params[:director] != nil
        #   @movies = @movies.where("director like ?", "%#{params[:director]}%")
        # end

        @movies = @movies.search_title(@movies, params[:title])
        @movies = @movies.search_director(@movies, params[:director])
        @movies = @movies.filter_by_runtime(@movies, params[:runtime])

        # if params[:runtime] != nil
        #   case params[:runtime]
        #     when "under90"
        #       @movies = @movies.where("runtime_in_minutes < ?", 90)
        #     when "between90and120"
        #       @movies = @movies.where("runtime_in_minutes >= ? AND runtime_in_minutes <= ?", 90, 120)
        #     when "over120"
        #       @movies = @movies.where("runtime_in_minutes > ?", 120)
        #   end
        # end
 
      end
     
      def show
        @movie = Movie.find(params[:id])
      end

      def new
        @movie = Movie.new
      end

      def edit
        @movie = Movie.find(params[:id])
      end

       def create
        @movie = Movie.new(movie_params)

        if @movie.save
          redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
        else
          render :new
        end
      end

      def update
        @movie = Movie.find(params[:id])

        if @movie.update_attributes(movie_params)
          redirect_to movie_path(@movie)
        else
          render :edit
        end
      end

      def destroy
        @movie = Movie.find(params[:id])
        @movie.destroy
        redirect_to movies_path
      end

      protected

      def movie_params
        params.require(:movie).permit(
          :title, :release_date, :director, :runtime_in_minutes, :poster_image_url, :description, :image, :remote_image_url
        )
      end

    end
