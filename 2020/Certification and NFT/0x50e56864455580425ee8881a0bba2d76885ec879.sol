['pragma solidity ^0.6.12;\n', '\n', '// SPDX-License-Identifier: BSD 3-Clause\n', '\n', '/**\n', ' * Development\n', ' * 3150 ZEE locked with smart contract for 10 months\n', ' * 315 ZEE will be vested every month from the smart contract\n', ' */\n', '\n', '/**\n', ' * @title SafeMath\n', ' * @dev Math operations with safety checks that throw on error\n', ' */\n', 'library SafeMath {\n', '  function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a * b;\n', '    assert(a == 0 || c / a == b);\n', '    return c;\n', '  }\n', '\n', '  function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '    uint256 c = a / b;\n', "    // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '    return c;\n', '  }\n', '\n', '  function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    assert(b <= a);\n', '    return a - b;\n', '  }\n', '\n', '  function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '    uint256 c = a + b;\n', '    assert(c >= a);\n', '    return c;\n', '  }\n', '}\n', '\n', '/**\n', ' * @title Ownable\n', ' * @dev The Ownable contract has an owner address, and provides basic authorization control\n', ' * functions, this simplifies the implementation of "user permissions".\n', ' */\n', 'contract Ownable {\n', '  address public owner;\n', '\n', '\n', '  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '\n', '  /**\n', '   * @dev The Ownable constructor sets the original `owner` of the contract to the sender\n', '   * account.\n', '   */\n', '  constructor() public {\n', '    owner = msg.sender;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Throws if called by any account other than the owner.\n', '   */\n', '  modifier onlyOwner() {\n', '    require(msg.sender == owner);\n', '    _;\n', '  }\n', '\n', '\n', '  /**\n', '   * @dev Allows the current owner to transfer control of the contract to a newOwner.\n', '   * @param newOwner The address to transfer ownership to.\n', '   */\n', '  function transferOwnership(address newOwner) onlyOwner public {\n', '    require(newOwner != address(0));\n', '    emit OwnershipTransferred(owner, newOwner);\n', '    owner = newOwner;\n', '  }\n', '}\n', '\n', '\n', 'interface Token {\n', '    function balanceOf(address) external returns (uint);\n', '    function transferFrom(address, address, uint) external returns (bool);\n', '    function transfer(address, uint) external returns (bool);\n', '}\n', '\n', 'contract TokenVestingLock is Ownable {\n', '    using SafeMath for uint;\n', '    \n', '    // enter token contract address here\n', '    address public constant tokenAddress =0xE53C708b667c47c370b4941224b3CA812bB8d1A5;\n', '    \n', '    // enter token locked amount here\n', '    uint public constant tokensLocked = 3150e18;\n', '    \n', '    uint public constant unlockRate = 10000;\n', '    \n', '    // enter unlock duration here\n', '    uint public constant lockDuration = 300 days;\n', '    \n', '    \n', '    uint public lastClaimedTime;\n', '    uint public deployTime;\n', '\n', '    \n', '    constructor() public {\n', '        deployTime = now;\n', '        lastClaimedTime = now;\n', '    }\n', '    \n', '    function claim() public onlyOwner {\n', '        uint pendingUnlocked = getPendingUnlocked();\n', '        uint contractBalance = Token(tokenAddress).balanceOf(address(this));\n', '        uint amountToSend = pendingUnlocked;\n', '        if (contractBalance < pendingUnlocked) {\n', '            amountToSend = contractBalance;\n', '        }\n', '        require(Token(tokenAddress).transfer(owner, amountToSend), "Could not transfer Tokens.");\n', '        lastClaimedTime = now;\n', '    }\n', '    \n', '    function getPendingUnlocked() public view returns (uint) {\n', '        uint timeDiff = now.sub(lastClaimedTime);\n', '        uint pendingUnlocked = tokensLocked\n', '                                    .mul(unlockRate)\n', '                                    .mul(timeDiff)\n', '                                    .div(lockDuration)\n', '                                    .div(1e4);\n', '        return pendingUnlocked;\n', '    }\n', '    \n', '    // function to allow admin to claim *other* ERC20 tokens sent to this contract (by mistake)\n', '    function transferAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {\n', '        require(_tokenAddr != tokenAddress, "Cannot transfer out reward tokens");\n', '        Token(_tokenAddr).transfer(_to, _amount);\n', '    }\n', '\n', '}']