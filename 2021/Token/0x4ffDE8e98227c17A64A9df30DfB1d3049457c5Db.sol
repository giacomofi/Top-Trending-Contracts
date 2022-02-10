['pragma solidity 0.8.0;\n', '\n', 'import "@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '\n', 'contract MuseStaker {\n', '    IERC20 public MUSE = IERC20(0xB6Ca7399B4F9CA56FC27cBfF44F4d2e4Eef1fc81);\n', '\n', '    mapping(address => uint256) public shares;\n', '    mapping(address => uint256) public timeLock;\n', '    mapping(address => uint256) public amountLocked;\n', '\n', '    uint256 public totalShares;\n', '    uint256 public unlockPeriod = 10 days;\n', '\n', '    address public owner;\n', '\n', '    constructor() {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    function changeUnlockPeriod(uint256 _period) external {\n', '        require(msg.sender == owner, "forbidden");\n', '        unlockPeriod = _period;\n', '    }\n', '\n', '    function stake(uint256 _amount) public {\n', '        timeLock[msg.sender] = 0; //reset timelock in case they stake twice.\n', '        amountLocked[msg.sender] = amountLocked[msg.sender] + _amount;\n', '        uint256 totalMuse = MUSE.balanceOf(address(this));\n', '        if (totalShares == 0 || totalMuse == 0) {\n', '            shares[msg.sender] = _amount;\n', '            totalShares += _amount;\n', '        } else {\n', '            uint256 bal = (_amount * totalShares) / (totalMuse);\n', '            shares[msg.sender] += bal;\n', '            totalShares += bal;\n', '        }\n', '        MUSE.transferFrom(msg.sender, address(this), _amount);\n', '    }\n', '\n', '    function startUnstake() public {\n', '        timeLock[msg.sender] = block.timestamp + unlockPeriod;\n', '    }\n', '\n', '    // requires timeLock to be up to 2 days after release tiemstamp.\n', '    function unstake() public {\n', '        uint256 lockedUntil = timeLock[msg.sender];\n', '        timeLock[msg.sender] = 0;\n', '        require(\n', '            lockedUntil != 0 &&\n', '                block.timestamp >= lockedUntil &&\n', '                block.timestamp <= lockedUntil + 2 days,\n', '            "!still locked"\n', '        );\n', '        _unstake();\n', '    }\n', '\n', '    function _unstake() internal {\n', '        uint256 bal =\n', '            (shares[msg.sender] * MUSE.balanceOf(address(this))) /\n', '                (totalShares);\n', '        totalShares -= shares[msg.sender];\n', '        shares[msg.sender] = 0; //burns the share from this user;\n', '        amountLocked[msg.sender] = 0;\n', '        MUSE.transfer(msg.sender, bal);\n', '    }\n', '\n', '    function claim() public {\n', '        uint256 amount = amountLocked[msg.sender];\n', '        _unstake(); // Send locked muse + reward to user\n', '        stake(amount); // Stake back only the original stake\n', '    }\n', '\n', '    function balance(address _user) public view returns (uint256) {\n', '        if (totalShares == 0) {\n', '            return 0;\n', '        }\n', '        uint256 bal =\n', '            (shares[_user] * MUSE.balanceOf(address(this))) / (totalShares);\n', '        return bal;\n', '    }\n', '\n', '    function userInfo(address _user)\n', '        public\n', '        view\n', '        returns (\n', '            uint256 bal,\n', '            uint256 claimable,\n', '            uint256 deposited,\n', '            uint256 timelock,\n', '            bool isClaimable,\n', '            uint256 globalShares,\n', '            uint256 globalBalance\n', '        )\n', '    {\n', '        bal = balance(_user);\n', '        if (bal > amountLocked[_user]) {\n', '            claimable = bal - amountLocked[_user];\n', '        }\n', '        deposited = amountLocked[_user];\n', '        timelock = timeLock[_user];\n', '        isClaimable = (timelock != 0 &&\n', '            block.timestamp >= timelock &&\n', '            block.timestamp <= timelock + 2 days);\n', '        globalShares = totalShares;\n', '        globalBalance = MUSE.balanceOf(address(this));\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']