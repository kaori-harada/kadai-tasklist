class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit]
  before_action :correct_user, only: [:destroy]
  
  def index
    if logged_in?
      @task = current_user.tasks.build  #form_with用
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
    end
  end
  
  def show
    @task = Task.find(params[:id])
  end
  
  def new
    @task = Task.new
  end
  
  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'タスクが正常に登録されました'
      redirect_to @task
      
    else
      flash.now[:danger] = 'タスクが登録されませんでした'
      render :new
    end
  end

  def edit
    @task = current_user.tasks.find(params[:id])
  end

  def update
    @task = current_user.tasks.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @task = correct_user.tasks.find(params[:id])
    @task.destroy
    
    flash[:success] = 'タスクは正常に削除されました'
    redirect_to tasks_url
  end

  
  private
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  # Strong Parameter
  def task_params
    params.require(:task).permit(:status, :content)
  end
  
    def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
      unless @task
       redirect_to root_url
      end
    end

end
