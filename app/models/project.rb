# == Schema Information
#
# Table name: projects
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  username        :string(255)
#  description     :text
#  created_at      :datetime
#  updated_at      :datetime
#  repository_data :json
#

class Project < ActiveRecord::Base
  validates :name, :username, presence: true, allow_blank: false
  validates_uniqueness_of :name, scope: :username

  def clone_url
    "git@github.com:#{username}/#{name}.git"
  end

  def download_zip_url(branch: 'master')
    "https://github.com/#{username}/#{name}/archive/#{branch}.zip"
  end

  def fetch_github_repository_data
    github_api.repos.get(username, name).to_h.with_indifferent_access
  end

  def update_repository_data
    repository_data = fetch_github_repository_data
    save! unless repository_data.nil?
  end

  def default_branch
    #json = curl "https://api.github.com/repos/#{username}/#{name}"
    fetch_github_repository_data if repository_data.blank?

    repository_data['default_branch']
  end

  def project_updated?
    github = fetch_github_repository_data

    repository_data[:pushed_at] != github[:pushed_at]
  end

  private

  def github_api
    @github_api ||= Github.new
  end
end