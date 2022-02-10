['/**\n', ' *Submitted for verification at Etherscan.io on 2021-03-02\n', '*/\n', '\n', 'pragma solidity ^0.7.6;\n', '\n', 'interface IPayable {\n', '    fallback() external payable;\n', '}\n', '\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract ZippieAccountERC20 {\n', '  address private owner;\n', '\n', '  constructor() {\n', '    owner = msg.sender; // Zippie Wallet\n', '  }\n', '\n', '  /**\n', '    * @dev Approve owner to send a specific ERC20 token (max 2^256)\n', '    * @param token token to be approved\n', '    */\n', '  function flushETHandTokens(address token, address payable to) public {\n', '    require(msg.sender == owner);\n', '    IERC20(token).transfer(to, IERC20(token).balanceOf(address(this)));\n', '    selfdestruct(to); // Sponsor (any available ETH will be sent here)\n', '  }\n', '  \n', '  function flushETH(address payable to) public {\n', '    require(msg.sender == owner);\n', '    selfdestruct(to); // Sponsor (any available ETH will be sent here)\n', '  }\n', '}\n', '\n', 'contract ZippieAccountERC20Deployer {\n', '    address payable public _owner;\n', '\n', '    constructor (address payable owner) {\n', '        _owner = owner;\n', '    }\n', '    \n', '    function setOwner(address payable newOwner) public {\n', "        require(msg.sender == _owner, 'A');\n", '        _owner = newOwner;\n', '    }\n', '    \n', '    function batchSweepETH(bytes32[] calldata _salt) public {\n', "        require(msg.sender == _owner, 'A');\n", '        \n', '        uint i;\n', '    \n', '        for (i = 0; i < _salt.length; i++) {\n', '            ZippieAccountERC20 account = new ZippieAccountERC20{salt: _salt[i]}();\n', '            account.flushETH(_owner);\n', '        }\n', '    }\n', '        \n', '    function batchSweepETHandTokens(IERC20[] calldata tokens, bytes32[] calldata _salt) public {\n', "        require(msg.sender == _owner, 'A');\n", '\n', "        require(tokens.length == _salt.length, 'B');\n", '\n', '        uint i;\n', '        for (i = 0; i < tokens.length; i++) {\n', '            ZippieAccountERC20 account = new ZippieAccountERC20{salt: _salt[i]}();\n', '            account.flushETHandTokens(address(tokens[i]), _owner);\n', '        }\n', '    }\n', '        \n', '    function getAddress(bytes32 _salt) public view returns (address) {\n', '        address predictedAddress = address(uint160(uint(keccak256(abi.encodePacked(\n', '            bytes1(0xff),\n', '            address(this),\n', '            _salt,\n', '            keccak256(abi.encodePacked(\n', '                type(ZippieAccountERC20).creationCode)  \n', '            ))\n', '        ))));\n', '        return predictedAddress;\n', '    }\n', '}']