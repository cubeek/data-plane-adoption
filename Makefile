TEST_INVENTORY ?= tests/inventory.yaml
TEST_VARS ?= tests/vars.yaml
TEST_SECRETS ?= tests/secrets.yaml
TEST_CONFIG ?= tests/ansible.cfg
TEST_ARGS ?=

### TESTS ###

test-minimal: TEST_OUTFILE := tests/logs/test_minimal_out_$(shell date +%FT%T%Z).log
test-minimal:
	mkdir -p tests/logs
	ANSIBLE_CONFIG=$(TEST_CONFIG) ansible-playbook -v -i $(TEST_INVENTORY) -e @$(TEST_VARS) -e @$(TEST_SECRETS) $(TEST_ARGS) tests/playbooks/test_minimal.yaml 2>&1 | tee $(TEST_OUTFILE)

test-with-ceph: TEST_OUTFILE := tests/logs/test_with_ceph_out_$(shell date +%FT%T%Z).log
test-with-ceph:
	mkdir -p tests/logs
	ANSIBLE_CONFIG=$(TEST_CONFIG) ansible-playbook -v -i $(TEST_INVENTORY) -e @$(TEST_VARS) -e @$(TEST_SECRETS) $(TEST_ARGS) tests/playbooks/test_with_ceph.yaml 2>&1 | tee $(TEST_OUTFILE)

test-swift-migration: TEST_OUTFILE := tests/logs/test_swift_migration_out_$(shell date +%FT%T%Z).log
test-swift-migration:
	mkdir -p tests/logs
	ANSIBLE_CONFIG=$(TEST_CONFIG) ansible-playbook -v -i $(TEST_INVENTORY) -e @$(TEST_VARS) -e @$(TEST_SECRETS) $(TEST_ARGS) tests/playbooks/test_swift_migration.yaml 2>&1 | tee $(TEST_OUTFILE)

test-rollback-minimal: TEST_OUTFILE := tests/logs/test_rollback_minimal_out_$(shell date +%FT%T%Z).log
test-rollback-minimal:
	mkdir -p tests/logs
	ANSIBLE_CONFIG=$(TEST_CONFIG) ansible-playbook -v -i $(TEST_INVENTORY) -e @$(TEST_VARS) -e @$(TEST_SECRETS) $(TEST_ARGS) tests/playbooks/test_rollback_minimal.yaml 2>&1 | tee $(TEST_OUTFILE)

test-rollback-with-ceph: TEST_OUTFILE := tests/logs/test_rollback_with_ceph_out_$(shell date +%FT%T%Z).log
test-rollback-with-ceph:
	mkdir -p tests/logs
	ANSIBLE_CONFIG=$(TEST_CONFIG) ansible-playbook -v -i $(TEST_INVENTORY) -e @$(TEST_VARS) -e @$(TEST_SECRETS) $(TEST_ARGS) tests/playbooks/test_rollback_with_ceph.yaml 2>&1 | tee $(TEST_OUTFILE)

test-with-ironic: TEST_OUTFILE := tests/logs/test_with_ironic_out_$(shell date +%FT%T%Z).log
test-with-ironic:
	mkdir -p tests/logs
	ANSIBLE_CONFIG=$(TEST_CONFIG) ansible-playbook -v -i $(TEST_INVENTORY) -e @$(TEST_VARS) -e @$(TEST_SECRETS) tests/playbooks/test_with_ironic.yaml 2>&1 | tee $(TEST_OUTFILE)

### DOCS ###

docs-dependencies: .bundle

.bundle:
	if ! type bundle; then \
		echo "Bundler not found. On Linux run 'sudo dnf install /usr/bin/bundle' to install it."; \
		exit 1; \
	fi

	bundle config set --local path 'local/bundle'; bundle install

docs: docs-dependencies docs-user-all-variants docs-dev

docs-user-all-variants:
	cd docs_user; BUILD=upstream $(MAKE) html
	cd docs_user; BUILD=downstream $(MAKE) html

docs-user:
	cd docs_user; $(MAKE) html

docs-user-open:
	cd docs_user; $(MAKE) open-html

docs-user-watch:
	cd docs_user; $(MAKE) watch-html

docs-dev:
	cd docs_dev; $(MAKE) html

docs-dev-open:
	cd docs_dev; $(MAKE) open-html

docs-dev-watch:
	cd docs_dev; $(MAKE) watch-html

docs-clean:
	rm -r docs_build
