require 'rails_helper'

RSpec.describe Project, type: :model do
  
  #Projectはプロジェクト名とownerが必要
  it "is valid with name and owner" do
    project = FactoryBot.build(:project)
    expect(project).to be_valid
  end

  #nameのプレセンステスト
  it "is invalid without a project name" do
    project = FactoryBot.build(:project, name: nil)
    project.valid?
    expect(project.errors[:name]).to include("can't be blank")
  end

  
  #ユーザー単位では重複したプロジェクト名を許可しない
  it "does not allow duplicate project names per user" do
    user = FactoryBot.create(:user)
    user.projects.create(name: "Test Project")
    new_project = user.projects.build(name: "Test Project")
    new_project.valid?
    expect(new_project.errors[:name]).to include("has already been taken")
  end

  #二人のユーザーが同じプロジェクト名を使うことは許可すること
  it "allows two users to share a project name" do
    user       = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user)
    
    user.projects.create(name: "Test Project")

    other_project = other_user.projects.build(name: "Test Project")

    expect(other_project).to be_valid
  end

  # 遅延ステータス
  describe "late status" do
    #締め切り日が過ぎていると遅延していること
    it "is late when the due date is late" do
      project = FactoryBot.create(:project, :project_due_yesterday)
      expect(project).to be_late
    end

    #締め切り日が今日ならスケジュール通りであること
    it "is on time the due date is today" do
      project = FactoryBot.create(:project, :project_due_today)
      expect(project).to_not be_late
    end

    #締め切り日が明日ならスケジュール通りであること
    it "is on time the due date is in future" do
      project = FactoryBot.create(:project, :project_due_tomorrow)
      expect(project).to_not be_late
    end
  end

    it "can has many notes" do
      project = FactoryBot.create(:project, :with_notes)
      expect(project.notes.count).to eq 5 
    end


end
