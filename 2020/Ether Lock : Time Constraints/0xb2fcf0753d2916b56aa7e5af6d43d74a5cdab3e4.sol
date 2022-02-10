['pragma solidity ^0.6.12;\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '// YSFI is DeFi. So interface name is YSFI\n', '\n', 'interface YSFI {\n', '    function balanceOf(address) external returns (uint);\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '    function transfer(address, uint) external returns (bool);\n', '}\n', '\n', 'contract YearnStackingLock is Ownable {\n', '    using SafeMath for uint;\n', '    \n', '    address public constant tokenAddress = 0x0f10b084b96a676E678753726DeD0b674c5daf67;\n', '    \n', '    uint public constant tokensLocked = 4000e18;       // 4000 YSFI \n', '    uint public constant unlockRate =   4000;          // 4000 YSFI unlocking at a time\n', '    uint public constant lockDuration = 270 days;       // Unlocking Possible after 270 days or 9 month\n', '    uint public lastClaimedTime;\n', '    uint public deployTime;\n', '\n', '    \n', '    constructor() public {\n', '        deployTime = now;\n', '        lastClaimedTime = now;\n', '    }\n', '    \n', '    function claim() public onlyOwner {\n', '        uint pendingUnlocked = getPendingUnlocked();\n', '        uint contractBalance = YSFI(tokenAddress).balanceOf(address(this));\n', '        uint amountToSend = pendingUnlocked;\n', '        if (contractBalance < pendingUnlocked) {\n', '            amountToSend = contractBalance;\n', '        }\n', '        require(YSFI(tokenAddress).transfer(owner, amountToSend), "Could not transfer Tokens.");\n', '        lastClaimedTime = now;\n', '    }\n', '    \n', '    function getPendingUnlocked() public view returns (uint) {\n', '        uint timeDiff = now.sub(lastClaimedTime);\n', '        uint pendingUnlocked = tokensLocked\n', '                                    .mul(unlockRate)\n', '                                    .mul(timeDiff)\n', '                                    .div(lockDuration)\n', '                                    .div(1e4);\n', '        return pendingUnlocked;\n', '    }\n', '    \n', '    // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)\n', '    function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {\n', '        require(_tokenAddr != tokenAddress, "Cannot transfer out reward tokens");\n', '        YSFI(_tokenAddr).transfer(_to, _amount);\n', '    }\n', '\n', '}']