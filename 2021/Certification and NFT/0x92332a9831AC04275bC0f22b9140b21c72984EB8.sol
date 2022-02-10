['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-26\n', '*/\n', '\n', '// Copyright (C) 2020 Centrifuge\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', 'pragma solidity >=0.5.15 <0.6.0;\n', '\n', '// Copyright (C) Centrifuge 2020, based on MakerDAO dss https://github.com/makerdao/dss\n', '//\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU Affero General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '//\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU Affero General Public License for more details.\n', '//\n', '// You should have received a copy of the GNU Affero General Public License\n', '// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity >=0.5.15 <0.6.0;\n', '\n', "/// note.sol -- the `note' modifier, for logging calls as events\n", '\n', '// This program is free software: you can redistribute it and/or modify\n', '// it under the terms of the GNU General Public License as published by\n', '// the Free Software Foundation, either version 3 of the License, or\n', '// (at your option) any later version.\n', '\n', '// This program is distributed in the hope that it will be useful,\n', '// but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '// GNU General Public License for more details.\n', '\n', '// You should have received a copy of the GNU General Public License\n', '// along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', 'pragma solidity >=0.4.23;\n', '\n', 'contract DSNote {\n', '    event LogNote(\n', '        bytes4   indexed  sig,\n', '        address  indexed  guy,\n', '        bytes32  indexed  foo,\n', '        bytes32  indexed  bar,\n', '        uint256           wad,\n', '        bytes             fax\n', '    ) anonymous;\n', '\n', '    modifier note {\n', '        bytes32 foo;\n', '        bytes32 bar;\n', '        uint256 wad;\n', '\n', '        assembly {\n', '            foo := calldataload(4)\n', '            bar := calldataload(36)\n', '            wad := callvalue()\n', '        }\n', '\n', '        _;\n', '\n', '        emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);\n', '    }\n', '}\n', '\n', 'contract Auth is DSNote {\n', '    mapping (address => uint) public wards;\n', '    function rely(address usr) public auth note { wards[usr] = 1; }\n', '    function deny(address usr) public auth note { wards[usr] = 0; }\n', '    modifier auth { require(wards[msg.sender] == 1); _; }\n', '}\n', '\n', 'interface AuthLike {\n', '    function rely(address) external;\n', '    function deny(address) external;\n', '}\n', '\n', 'interface DependLike {\n', '    function depend(bytes32, address) external;\n', '}\n', '\n', 'interface BorrowerDeployerLike {\n', '    function collector() external returns (address);\n', '    function feed() external returns (address);\n', '    function shelf() external returns (address);\n', '    function title() external returns (address);\n', '    function pile() external returns (address);\n', '}\n', 'interface LenderDeployerLike {\n', '    function assessor() external returns (address);\n', '    function reserve() external returns (address);\n', '    function assessorAdmin() external returns (address);\n', '    function juniorMemberlist() external returns (address);\n', '    function seniorMemberlist() external returns (address);\n', '    function juniorOperator() external returns (address);\n', '    function seniorOperator() external returns (address);\n', '    function coordinator() external returns (address);\n', '}\n', '\n', '\n', 'contract TinlakeRoot is Auth {\n', '    BorrowerDeployerLike public borrowerDeployer;\n', '    LenderDeployerLike public  lenderDeployer;\n', '\n', '    bool public             deployed;\n', '    address public          deployUsr;\n', '\n', '    constructor (address deployUsr_) public {\n', '        deployUsr = deployUsr_;\n', '    }\n', '\n', '    // --- Prepare ---\n', '    // Sets the two deployer dependencies. This needs to be called by the deployUsr\n', '    function prepare(address lender_, address borrower_, address ward_) public {\n', '        require(deployUsr == msg.sender);\n', '        borrowerDeployer = BorrowerDeployerLike(borrower_);\n', '        lenderDeployer = LenderDeployerLike(lender_);\n', '        wards[ward_] = 1;\n', '        deployUsr = address(0); // disallow the deploy user to call this more than once.\n', '    }\n', '\n', '    // --- Deploy ---\n', '    // After going through the deploy process on the lender and borrower method, this method is called to connect\n', '    // lender and borrower contracts.\n', '    function deploy() public {\n', '        require(address(borrowerDeployer) != address(0) && address(lenderDeployer) != address(0) && deployed == false);\n', '        deployed = true;\n', '\n', '        address reserve_ = lenderDeployer.reserve();\n', '        address shelf_ = borrowerDeployer.shelf();\n', '\n', '        // Borrower depends\n', '        DependLike(borrowerDeployer.collector()).depend("distributor", reserve_);\n', '        DependLike(borrowerDeployer.shelf()).depend("lender", reserve_);\n', '        DependLike(borrowerDeployer.shelf()).depend("distributor", reserve_);\n', '\n', '        //AuthLike(reserve).rely(shelf_);\n', '\n', '        //  Lender depends\n', '        address navFeed = borrowerDeployer.feed();\n', '\n', '        DependLike(reserve_).depend("shelf", shelf_);\n', '        DependLike(lenderDeployer.assessor()).depend("navFeed", navFeed);\n', '\n', '        // Permissions\n', '        address poolAdmin1 = 0x24730a9D68008c6Bd8F43e60Ed2C00cbe57Ac829;\n', '        address poolAdmin2 = 0x71d9f8CFdcCEF71B59DD81AB387e523E2834F2b8;\n', '        address poolAdmin3 = 0xa7Aa917b502d86CD5A23FFbD9Ee32E013015e069;\n', '        address poolAdmin4 = 0xfEADaD6b75e6C899132587b7Cb3FEd60c8554821;\n', '        address poolAdmin5 = 0xC3997Ef807A24af6Ca5Cb1d22c2fD87C6c3b79E8;\n', '        address poolAdmin6 = 0xd60f7CFC1E051d77031aC21D9DB2F66fE54AE312;\n', '        address poolAdmin7 = 0x46a71eEf8DbcFcbAC7A0e8D5d6B634A649e61fb8;\n', '        address oracle = 0x8F1afCFDB6B4264B8fbFfBB9ca900e66187543cf;\n', '\n', '        AuthLike(lenderDeployer.assessorAdmin()).rely(poolAdmin1);\n', '        AuthLike(lenderDeployer.assessorAdmin()).rely(poolAdmin2);\n', '        AuthLike(lenderDeployer.assessorAdmin()).rely(poolAdmin3);\n', '        AuthLike(lenderDeployer.assessorAdmin()).rely(poolAdmin4);\n', '        AuthLike(lenderDeployer.assessorAdmin()).rely(poolAdmin5);\n', '        AuthLike(lenderDeployer.assessorAdmin()).rely(poolAdmin6);\n', '        AuthLike(lenderDeployer.assessorAdmin()).rely(poolAdmin7);\n', '\n', '        AuthLike(lenderDeployer.juniorMemberlist()).rely(poolAdmin1);\n', '        AuthLike(lenderDeployer.juniorMemberlist()).rely(poolAdmin2);\n', '        AuthLike(lenderDeployer.juniorMemberlist()).rely(poolAdmin3);\n', '        AuthLike(lenderDeployer.juniorMemberlist()).rely(poolAdmin4);\n', '        AuthLike(lenderDeployer.juniorMemberlist()).rely(poolAdmin5);\n', '        AuthLike(lenderDeployer.juniorMemberlist()).rely(poolAdmin6);\n', '        AuthLike(lenderDeployer.juniorMemberlist()).rely(poolAdmin7);\n', '\n', '        AuthLike(lenderDeployer.seniorMemberlist()).rely(poolAdmin1);\n', '        AuthLike(lenderDeployer.seniorMemberlist()).rely(poolAdmin2);\n', '        AuthLike(lenderDeployer.seniorMemberlist()).rely(poolAdmin3);\n', '        AuthLike(lenderDeployer.seniorMemberlist()).rely(poolAdmin4);\n', '        AuthLike(lenderDeployer.seniorMemberlist()).rely(poolAdmin5);\n', '        AuthLike(lenderDeployer.seniorMemberlist()).rely(poolAdmin6);\n', '        AuthLike(lenderDeployer.seniorMemberlist()).rely(poolAdmin7);\n', '\n', '        AuthLike(navFeed).rely(oracle);\n', '    }\n', '\n', '    // --- Governance Functions ---\n', '    // `relyContract` & `denyContract` can be called by any ward on the TinlakeRoot\n', '    // contract to make an arbitrary address a ward on any contract the TinlakeRoot\n', '    // is a ward on.\n', '    function relyContract(address target, address usr) public auth {\n', '        AuthLike(target).rely(usr);\n', '    }\n', '\n', '    function denyContract(address target, address usr) public auth {\n', '        AuthLike(target).deny(usr);\n', '    }\n', '\n', '}']