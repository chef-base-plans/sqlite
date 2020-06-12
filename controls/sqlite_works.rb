title 'Tests to confirm sqlite binary works as expected'

base_dir = input("base_dir", value: "bin")
plan_origin = ENV['HAB_ORIGIN']
plan_name = input("plan_name", value: "sqlite")
plan_ident = "#{plan_origin}/#{plan_name}"

control 'core-plans-sqlite' do
  impact 1.0
  title 'Ensure sqlite binary is working as expected'
  desc '
We first check that the sqlite binary we expect is present and then run a version check to verify that it is excecutable.
  '

  hab_pkg_path = command("hab pkg path #{plan_ident}")
  describe hab_pkg_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty}
  end

  target_dir = File.join(hab_pkg_path.stdout.strip, base_dir)

  sqlite_exists = command("ls #{File.join(target_dir, "sqlite3")}")
  describe sqlite_exists do
    its('stdout') { should match /sqlite3/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end

  sqlite_works = command("/bin/sqlite3 --version")
  describe sqlite_works do
    its('stdout') { should match /[0-9]+.[0-9]+.[0-9]+/ }
    its('stderr') { should be_empty }
    its('exit_status') { should eq 0 }
  end
end
