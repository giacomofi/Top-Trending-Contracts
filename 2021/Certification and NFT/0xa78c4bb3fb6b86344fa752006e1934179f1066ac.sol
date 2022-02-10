['/**\n', ' *Submitted for verification at Etherscan.io on 2021-05-24\n', '*/\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity >=0.6.6;\n', '\n', 'interface IVoteProxy {\n', '    function decimals() external pure returns (uint8);\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address _voter) external view returns (uint256);\n', '}\n', '\n', 'contract popVoteProxy {\n', '    IVoteProxy public voteProxy;\n', '    address public governance;\n', '\n', '    constructor() public {\n', '        governance = msg.sender;\n', '    }\n', '\n', '    function name() external pure returns (string memory) {\n', '        return "POP Vote Power";\n', '    }\n', '\n', '    function symbol() external pure returns (string memory) {\n', '        return "POP VP";\n', '    }\n', '\n', '    function decimals() external view returns (uint8) {\n', '        return voteProxy.decimals();\n', '    }\n', '\n', '    function totalSupply() external view returns (uint256) {\n', '        return voteProxy.totalSupply();\n', '    }\n', '\n', '    function balanceOf(address _voter) external view returns (uint256) {\n', '        return voteProxy.balanceOf(_voter);\n', '    }\n', '\n', '    function setVoteProxy(IVoteProxy _voteProxy) external {\n', '        require(msg.sender == governance, "!governance");\n', '        voteProxy = _voteProxy;\n', '    }\n', '\n', '    function setGovernance(address _governance) external {\n', '        require(msg.sender == governance, "!governance");\n', '        governance = _governance;\n', '    }\n', '}']