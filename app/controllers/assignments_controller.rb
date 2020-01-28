class AssignmentsController < ApplicationController
  before_action :load_node, except: [:show, :edit, :update, :destroy, :update_attrs]
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]

  # GET /assignments
  # GET /assignments.json
  def index
    @assignments = current_user.assignments
  end
  
  def task_review
    @assignment = Assignment.find(params[:assignment_id])
    if current_user.user_role == "admin"
      if params[:status]=="approve"
        @assignment.update_attributes(status: "a")
        if @assignment.node.parent.name == "Production"
          @assignment.update_attributes(end_date: DateTime.now)
        end
      elsif params[:status]=="revision"
        @assignment.update_attributes(status: "r")
       elsif params[:status]=="submission"
        @assignment.update_attributes(status: "wa")
      end
      redirect_to node_path(@assignment.node.parent.parent.id)
    else
      if params[:status]=="submission"
        @assignment.update_attributes(status: "wa")
      end
      redirect_to assignment_path(@assignment)
    end
  end
  # GET /assignments/1
  # GET /assignments/1.json
  def show
    # @notes = @assignment.notes.build
  end

  # GET /assignments/new
  def new
    @assignment = @node.assignments.new
  end

  # GET /assignments/1/edit
  def edit
  end

  # POST /assignments
  # POST /assignments.json
  def create
    @assignment = Assignment.new(assignment_params)

    respond_to do |format|
      if @assignment.save
        format.html { redirect_to node_path(@assignment.node.root.id), notice: 'Assignment was successfully created.' }
        format.json { render :show, status: :created, location: @assignment }
      else
        format.html { render :new }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /assignments/1
  # PATCH/PUT /assignments/1.json
  def update
    respond_to do |format|
      if @assignment.update(assignment_params)
        format.html { redirect_to @assignment, notice: 'Assignment was successfully updated.' }
        format.json { render :show, status: :ok, location: @assignment }
      else
        format.html { render :edit }
        format.json { render json: @assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /assignments/1
  # DELETE /assignments/1.json
  def destroy
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to assignments_url, notice: 'Assignment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    def load_node
      @node = Node.find(params[:node_id]) if params[:node_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:status, :start_date, :end_date, :completition_date, :description, :node_id, :user_id)
    end
end
