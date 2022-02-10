['pragma solidity ^0.6.0;\n', '// SPDX-License-Identifier: UNLICENSED\n', '// ----------------------------------------------------------------------------\n', '// ERC Token Standard #20 Interface\n', '// ----------------------------------------------------------------------------\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address tokenOwner) external view returns (uint256 balance);\n', '    function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);\n', '    function transfer(address to, uint256 tokens) external returns (bool success);\n', '    function approve(address spender, uint256 tokens) external returns (bool success);\n', '    function transferFrom(address from, address to, uint256 tokens) external returns (bool success);\n', '    function burnTokens(uint256 _amount) external;\n', '    function _transfer(address to, uint256 tokens) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 tokens);\n', '    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);\n', '}\n', '\n', '\n', 'contract SYFP_SWAP{\n', '    address YFP_address = 0x96d62cdCD1cc49cb6eE99c867CB8812bea86B9FA;\n', '    address SYFP_address = 0xC11396e14990ebE98a09F8639a082C03Eb9dB55a;\n', '    \n', '    function SWAP(uint256 _tokens) public{\n', '        require(IERC20(YFP_address).transferFrom(address(msg.sender), address(this), _tokens), "Transfer of funds failed!");\n', '        IERC20(YFP_address).transfer(address(0), _tokens);\n', '       \n', '        require(IERC20(SYFP_address)._transfer(msg.sender, _tokens), "SYFP Tokens Not available");\n', '    }\n', '   \n', '}']