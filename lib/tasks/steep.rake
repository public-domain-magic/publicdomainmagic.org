# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: LicenseRef-LICENSE
#++

desc "Run Steep type checker"
task :steep do
  sh "bundle exec steep check"
end
