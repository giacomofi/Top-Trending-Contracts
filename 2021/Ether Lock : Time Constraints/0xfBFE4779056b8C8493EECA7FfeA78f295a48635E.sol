['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-14\n', '*/\n', '\n', '// SPDX-License-Identifier: AGPL-3.0-only\n', 'pragma solidity >=0.4.23 >=0.5.15;\n', '\n', '// Copyright (C) Centrifuge 2020, based on MakerDAO dss https://github.com/makerdao/dss\n', '\n', 'contract Auth {\n', '    mapping (address => uint256) public wards;\n', '    \n', '    event Rely(address indexed usr);\n', '    event Deny(address indexed usr);\n', '\n', '    function rely(address usr) external auth {\n', '        wards[usr] = 1;\n', '        emit Rely(usr);\n', '    }\n', '    function deny(address usr) external auth {\n', '        wards[usr] = 0;\n', '        emit Deny(usr);\n', '    }\n', '\n', '    modifier auth {\n', '        require(wards[msg.sender] == 1, "not-authorized");\n', '        _;\n', '    }\n', '\n', '}\n', '\n', 'contract CfgRewardRate is Auth {\n', '\n', '    uint256 public investorRewardRate;\n', '    uint256 public aoRewardRate;\n', '\n', '    event RateUpdate(uint256 newInvestorRewardRate, uint256 newAoRewardRate);\n', '\n', '    constructor() {\n', '        wards[msg.sender] = 1;\n', '        emit Rely(msg.sender);\n', '    }\n', '\n', '    function get() public view returns (uint256, uint256) {\n', '        return (investorRewardRate, aoRewardRate);\n', '    }\n', '    \n', '    function set(uint256 investorRewardRate_, uint256 aoRewardRate_) public auth {\n', '        investorRewardRate = investorRewardRate_;\n', '        aoRewardRate = aoRewardRate_;\n', '        emit RateUpdate(investorRewardRate, aoRewardRate);\n', '    }\n', '\n', '}']