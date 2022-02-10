['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-14\n', '*/\n', '\n', 'pragma solidity ^0.8.4;\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract BAEAwards {\n', '\n', '    mapping(bytes32 => bool) public hashmap;\n', '    IERC20 baePay;\n', '    address _owner;\n', '\n', '    constructor(address _baePayAddress){\n', '        baePay = IERC20(_baePayAddress);\n', '        _owner = msg.sender;\n', '    }\n', '\n', '    function _verifyHash(bytes32 _hash, uint8 v, bytes32[2] memory rs) internal view returns (bool){\n', '        return ecrecover(keccak256(abi.encodePacked("\\x19Ethereum Signed Message:\\n32", _hash)), v, rs[0], rs[1]) == _owner;\n', '    }\n', '\n', '    function changeOwnership(address _newOwner) external{\n', '        require(msg.sender == _owner, "You Are Not The Owner");\n', '        _owner = _newOwner;\n', '    }\n', '\n', '    function withdrawBAEPay(uint256 _amount) external{\n', '        require(msg.sender == _owner, "You Are Not The Owner");\n', '        baePay.transfer(msg.sender, _amount);\n', '    }\n', '\n', '    function claimBAEPay(uint256 _amount, string memory _nonce, uint8 _v, bytes32[2] memory _rs) external{\n', '        bytes32 newHash = keccak256(abi.encodePacked(_amount, _nonce, msg.sender));\n', '        require(!hashmap[newHash], "Key Already Used");\n', '        require(_verifyHash(newHash, _v, _rs), "Invalid Key");\n', '        hashmap[newHash] = true;\n', '        baePay.transfer(msg.sender, _amount * 10 ** 4);\n', '    }\n', '\n', '}']