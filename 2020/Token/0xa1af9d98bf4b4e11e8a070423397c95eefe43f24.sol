['// SPDX-License-Identifier: MIT\n', 'pragma solidity 0.6.12;\n', '\n', 'interface IERC20 {\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '}\n', '\n', 'contract MultiAirdropINJ {\n', '    IERC20 public inj;\n', '    address public  owner;\n', '    mapping(address => uint256) public claimableAmounts;\n', '\n', '    constructor () public {\n', '        owner = msg.sender;\n', '        inj = IERC20(0xe28b3B32B6c345A34Ff64674606124Dd5Aceca30);\n', '    }\n', '\n', '    function safeAddAmountsToAirdrop(\n', '        address[] memory to,\n', '        uint256[] memory amounts\n', '    )\n', '    public\n', '    {\n', '        require(msg.sender == owner, "Only Owner");\n', '        require(to.length == amounts.length);\n', '        uint256 totalAmount;\n', '        for(uint256 i = 0; i < to.length; i++) {\n', '            claimableAmounts[to[i]] = amounts[i];\n', '            totalAmount += amounts[i];\n', '        }\n', '        require(inj.allowance(msg.sender, address(this)) >= totalAmount, "not enough allowance");\n', '        inj.transferFrom(msg.sender, address(this), totalAmount);\n', '    }\n', '\n', '    function returnINJ() external {\n', '        require(msg.sender == owner, "Only Owner");\n', '        require(inj.transfer(msg.sender, inj.balanceOf(address(this))), "Transfer failed");\n', '    }\n', '    \n', '    function returnAnyToken(IERC20 token) external {\n', '        require(msg.sender == owner, "Only Owner");\n', '        require(token.transfer(msg.sender, token.balanceOf(address(this))), "Transfer failed");\n', '    }\n', '\n', '    function claim() external {\n', '        require(claimableAmounts[msg.sender] > 0, "Cannot claim 0 tokens");\n', '        uint256 amount = claimableAmounts[msg.sender];\n', '        claimableAmounts[msg.sender] = 0;\n', '        require(inj.transfer(msg.sender, amount), "Transfer failed");\n', '    }\n', '\n', '    function claimFor(address _for) external {\n', '        require(claimableAmounts[_for] > 0, "Cannot claim 0 tokens");\n', '        uint256 amount = claimableAmounts[_for];\n', '        claimableAmounts[_for] = 0;\n', '        require(inj.transfer(_for, amount), "Transfer failed");\n', '    }\n', '    \n', '    function transferOwnerShip(address newOwner) external {\n', '        require(msg.sender == owner, "Only Owner");\n', '        owner = newOwner;\n', '    }\n', '}']