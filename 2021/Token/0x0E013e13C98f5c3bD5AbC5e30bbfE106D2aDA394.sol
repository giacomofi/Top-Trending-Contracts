['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-15\n', '*/\n', '\n', '// Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', '// pragma solidity >=0.6.0 <0.8.0;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', '\n', '// Dependency file: contracts/interfaces/IERC3156FlashBorrower.sol\n', '\n', '// pragma solidity >=0.6.0 <=0.8.0;\n', '\n', '\n', 'interface IERC3156FlashBorrower {\n', '\n', '    /**\n', '     * @dev Receive a flash loan.\n', '     * @param initiator The initiator of the loan.\n', '     * @param token The loan currency.\n', '     * @param amount The amount of tokens lent.\n', '     * @param fee The additional amount of tokens to repay.\n', '     * @param data Arbitrary data structure, intended to contain user-defined parameters.\n', '     * @return The keccak256 hash of "ERC3156FlashBorrower.onFlashLoan"\n', '     */\n', '    function onFlashLoan(\n', '        address initiator,\n', '        address token,\n', '        uint256 amount,\n', '        uint256 fee,\n', '        bytes calldata data\n', '    ) external returns (bytes32);\n', '}\n', '\n', '\n', '// Dependency file: contracts/interfaces/IERC3156FlashLender.sol\n', '\n', '// pragma solidity >=0.6.0 <=0.8.0;\n', '// import "contracts/interfaces/IERC3156FlashBorrower.sol";\n', '\n', '\n', 'interface IERC3156FlashLender {\n', '\n', '    /**\n', '     * @dev The amount of currency available to be lended.\n', '     * @param token The loan currency.\n', '     * @return The amount of `token` that can be borrowed.\n', '     */\n', '    function maxFlashLoan(\n', '        address token\n', '    ) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev The fee to be charged for a given loan.\n', '     * @param token The loan currency.\n', '     * @param amount The amount of tokens lent.\n', '     * @return The amount of `token` to be charged for the loan, on top of the returned principal.\n', '     */\n', '    function flashFee(\n', '        address token,\n', '        uint256 amount\n', '    ) external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Initiate a flash loan.\n', '     * @param receiver The receiver of the tokens in the loan, and the receiver of the callback.\n', '     * @param token The loan currency.\n', '     * @param amount The amount of tokens lent.\n', '     * @param data Arbitrary data structure, intended to contain user-defined parameters.\n', '     */\n', '    function flashLoan(\n', '        IERC3156FlashBorrower receiver,\n', '        address token,\n', '        uint256 amount,\n', '        bytes calldata data\n', '    ) external returns (bool);\n', '}\n', '\n', '// Root file: contracts/FlashBorrower.sol\n', '\n', 'pragma solidity >=0.6.5 <0.8.0;\n', '\n', '// import "/Users/sg99022ml/Desktop/chfry-protocol-internal/node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";\n', '// import "contracts/interfaces/IERC3156FlashBorrower.sol";\n', '// import "contracts/interfaces/IERC3156FlashLender.sol";\n', '\n', '//  FlashLoan DEMO\n', 'contract FlashBorrower is IERC3156FlashBorrower {\n', '    enum Action {NORMAL, STEAL, REENTER}\n', '\n', '    IERC3156FlashLender lender;\n', '\n', '    uint256 public flashBalance;\n', '    address public flashInitiator;\n', '    address public flashToken;\n', '    uint256 public flashAmount;\n', '    uint256 public flashFee;\n', '\n', '    address public admin;\n', '\n', '    constructor(address lender_) public {\n', '        admin = msg.sender;\n', '        lender = IERC3156FlashLender(lender_);\n', '    }\n', '    \n', '    function setLender(address _lender) external{\n', "        require(msg.sender == admin,'!admin');\n", '        lender = IERC3156FlashLender(_lender);\n', '    }\n', '\n', '    /// @dev ERC-3156 Flash loan callback\n', '    function onFlashLoan(\n', '        address initiator,\n', '        address token,\n', '        uint256 amount,\n', '        uint256 fee,\n', '        bytes calldata data\n', '    ) external override returns (bytes32) {\n', '        require(\n', '            msg.sender == address(lender),\n', '            "FlashBorrower: Untrusted lender"\n', '        );\n', '        require(\n', '            initiator == address(this),\n', '            "FlashBorrower: External loan initiator"\n', '        );\n', '        Action action = abi.decode(data, (Action)); // Use this to unpack arbitrary data\n', '        flashInitiator = initiator;\n', '        flashToken = token;\n', '        flashAmount = amount;\n', '        flashFee = fee;\n', '        if (action == Action.NORMAL) {\n', '            flashBalance = IERC20(token).balanceOf(address(this));\n', '        } else if (action == Action.STEAL) {\n', '            // do nothing\n', '        } else if (action == Action.REENTER) {\n', '            flashBorrow(token, amount * 2);\n', '        }\n', '        return keccak256("ERC3156FlashBorrower.onFlashLoan");\n', '    }\n', '\n', '    function flashBorrow(address token, uint256 amount) public {\n', '        // Use this to pack arbitrary data to `onFlashLoan`\n', '        bytes memory data = abi.encode(Action.NORMAL);\n', '        approveRepayment(token, amount);\n', '        lender.flashLoan(this, token, amount, data);\n', '    }\n', '\n', '    function flashBorrowAndSteal(address token, uint256 amount) public {\n', '        // Use this to pack arbitrary data to `onFlashLoan`\n', '        bytes memory data = abi.encode(Action.STEAL);\n', '        lender.flashLoan(this, token, amount, data);\n', '    }\n', '\n', '    function flashBorrowAndReenter(address token, uint256 amount) public {\n', '        // Use this to pack arbitrary data to `onFlashLoan`\n', '        bytes memory data = abi.encode(Action.REENTER);\n', '        approveRepayment(token, amount);\n', '        lender.flashLoan(this, token, amount, data);\n', '    }\n', '\n', '    function approveRepayment(address token, uint256 amount) public {\n', '        uint256 _allowance =\n', '            IERC20(token).allowance(address(this), address(lender));\n', '        uint256 _fee = lender.flashFee(token, amount);\n', '        uint256 _repayment = amount + _fee;\n', '        IERC20(token).approve(address(lender), 0);\n', '        IERC20(token).approve(address(lender), _allowance + _repayment);\n', '    }\n', '\n', '    function transferFromAdmin(\n', '\t\taddress _token,\n', '\t\taddress _receiver,\n', '\t\tuint256 _amount\n', '\t) external  {\n', "        require(msg.sender == admin,'!admin');\n", '\t\tIERC20(_token).transfer(_receiver, _amount);\n', '\t}\n', '}']