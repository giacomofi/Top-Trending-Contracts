['// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.4.23;\n', '\n', 'contract ERC20Basic {\n', '    function totalSupply() public view returns (uint256);\n', '    function balanceOf(address who) public view returns (uint256);\n', '    function transfer(address to, uint256 value) public returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns (uint256);\n', '    function transferFrom(address from, address to, uint256 value) public returns (bool);\n', '    function approve(address spender, uint256 value) public returns (bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '/**\n', ' * @dev A token holder contract that will allow a beneficiary to extract the\n', ' * tokens after a given release time.\n', ' *\n', ' * Useful for simple vesting schedules like "advisors get all of their tokens\n', ' * after 1 year".\n', ' */\n', 'contract TokenTimelock {\n', '    struct Timelock {\n', '      uint256 amount; // amount of tokens to lock\n', '      uint256 releaseTime; // timestamp when token release is enabled\n', '    }\n', '\n', '    // tokenAddress => ( ownerAddress => { amount, releaseTime } )\n', '    mapping(address => mapping(address => Timelock)) public timelockMap;\n', '\n', '    event TokenTimelocked(ERC20 indexed token, address indexed tokenOwner, uint256 amount, uint256 releaseTime);\n', '    event TokenTimelockReleased(ERC20 indexed token, address indexed tokenOwner, uint256 amount, uint256 releaseTime, uint256 blockTime);\n', '\n', '    constructor () public {}\n', '\n', '    /**\n', '     * @return the amount of tokens locked by the tokenOwner.\n', '     */\n', '    function getTokenOwnerLockAmount(ERC20 token, address tokenOwner) public view returns (uint256) {\n', '        return timelockMap[address(token)][tokenOwner].amount;\n', '    }\n', '    /**\n', '     * @return the releaseTime set by the tokenOwner.\n', '     */\n', '    function getTokenOwnerLockReleaseTime(ERC20 token, address tokenOwner) public view returns (uint256) {\n', '        return timelockMap[address(token)][tokenOwner].releaseTime;\n', '    }\n', '\n', '    /**\n', '     * @notice Locks senders tokens for the specified time\n', '     * Must approve the contract for transfering tokens before calling this function\n', '     */\n', '    function lock(ERC20 token, uint256 amount, uint256 releaseTime) public returns (bool) {\n', '        require(releaseTime > block.timestamp, "release time is before current time");\n', '        require(amount > 0, "token amount is invalid");\n', '        \n', '        address _tokenOwner = msg.sender;\n', '        address _tokenAddr = address(token);\n', '        require(_tokenAddr != address(0), "token address is invalid");\n', '        \n', '        Timelock storage _lock = timelockMap[_tokenAddr][_tokenOwner];\n', '        require(_lock.amount == 0 && _lock.releaseTime == 0, "a lock for the token & sender already exists");\n', '        require(token.transferFrom(_tokenOwner, address(this), amount), "transferFrom failed");\n', '\n', '        timelockMap[_tokenAddr][_tokenOwner] = Timelock(amount, releaseTime);\n', '        \n', '        emit TokenTimelocked(token, _tokenOwner, amount, releaseTime);\n', '        \n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @notice Transfers tokens held by timelock to tokenOwner.\n', '     */\n', '    function release(ERC20 token) public returns (bool) {\n', '        address _tokenAddr = address(token);\n', '        address _tokenOwner = msg.sender;\n', '        require(_tokenAddr != address(0), "token address is invalid");\n', '\n', '        Timelock storage _lock = timelockMap[_tokenAddr][_tokenOwner];\n', '        require(_lock.amount > 0 && _lock.releaseTime > 0, "a lock for the token & sender doesn\'t exist");\n', '        require(block.timestamp >= _lock.releaseTime, "current time is before release time");\n', '\n', '        uint256 balance = token.balanceOf(address(this));\n', '        require(_lock.amount <= balance, "not enough tokens to release");\n', '        require(token.transfer(_tokenOwner, _lock.amount), "transfer failed");\n', '\n', '        timelockMap[_tokenAddr][_tokenOwner].amount = 0;\n', '        timelockMap[_tokenAddr][_tokenOwner].releaseTime = 0;\n', '\n', '        emit TokenTimelockReleased(token, _tokenOwner, _lock.amount, _lock.releaseTime, block.timestamp);\n', '        \n', '        return true;\n', '    }\n', '}']