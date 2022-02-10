['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.5.16;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import {Ownable} from "../lib/Ownable.sol";\n', 'import {SafeERC20} from "../lib/SafeERC20.sol";\n', 'import {SafeMath} from "../lib/SafeMath.sol";\n', '\n', 'import {IMintableToken} from "../token/IMintableToken.sol";\n', 'import {BaseERC20} from "./BaseERC20.sol";\n', '\n', 'contract ArcxTokenV2 is BaseERC20, IMintableToken, Ownable {\n', '\n', '    /* ========== Libraries ========== */\n', '\n', '    using SafeMath for uint256;\n', '\n', '    /* ========== Variables ========== */\n', '\n', '    address public pauseOperator;\n', '    bool public isPaused;\n', '\n', '    uint8 public version;\n', '    BaseERC20 public oldArcxToken;\n', '\n', '    /* ========== Events ========== */\n', '\n', '    event Claimed(\n', '        address _owner,\n', '        uint256 _amount\n', '    );\n', '\n', '    event OtherOwnershipTransfered(\n', '        address _targetContract,\n', '        address _newOwner\n', '    );\n', '\n', '    event PauseStatusUpdated(bool _status);\n', '\n', '    event PauseOperatorUpdated(\n', '        address _pauseOperator\n', '    );\n', '\n', '    // ============ Modifiers ============\n', '\n', '    modifier pausable() {\n', '        require (\n', '            isPaused == false,\n', '            "ArcxTokenV2: contract is paused"\n', '        );\n', '        _;\n', '    }\n', '\n', '    // ============ Constructor ============\n', '\n', '    constructor(\n', '        address _oldArcxToken\n', '    )\n', '        public\n', '        BaseERC20("ARCX Governance Token", "ARCX", 18)\n', '    {\n', '        require(\n', '            _oldArcxToken != address(0),\n', '            "ArcxTokenV2: old ARCX token cannot be address 0"\n', '        );\n', '\n', '        oldArcxToken = BaseERC20(_oldArcxToken);\n', '        version = 2;\n', '\n', '        pauseOperator = msg.sender;\n', '        isPaused = false;\n', '    }\n', '\n', '    // ============ Core Functions ============\n', '\n', '    function mint(\n', '        address to,\n', '        uint256 value\n', '    )\n', '        external\n', '        onlyOwner\n', '        pausable\n', '    {\n', '        _mint(to, value);\n', '    }\n', '\n', '    function burn(\n', '        address to,\n', '        uint256 value\n', '    )\n', '        external\n', '        onlyOwner\n', '        pausable\n', '    {\n', '        _burn(to, value);\n', '    }\n', '\n', '    // ============ Migration Function ============\n', '\n', '    /**\n', '     * @dev Transfers the old tokens to the owner and\n', '     *      mints the new tokens, respecting a 1 : 10,000 ratio.\n', '     *\n', '     * @notice Convert the old tokens from the old ARCX token to the new (this one).\n', '     */\n', '    function claim()\n', '        external\n', '        pausable\n', '    {\n', '        uint256 balance = oldArcxToken.balanceOf(msg.sender);\n', '        uint256 newBalance = balance.mul(10000);\n', '\n', '        require(\n', '            balance > 0,\n', '            "ArcxTokenV2: user has 0 balance of old tokens"\n', '        );\n', '\n', '        // Burn old balance\n', '        IMintableToken oldToken = IMintableToken(address(oldArcxToken));\n', '\n', '        oldToken.burn(\n', '            msg.sender,\n', '            balance\n', '        );\n', '\n', '        // Mint new balance\n', '        _mint(\n', '            msg.sender,\n', '            newBalance\n', '        );\n', '\n', '        emit Claimed(\n', '            msg.sender,\n', '            newBalance\n', '        );\n', '    }\n', '\n', '    // ============ Restricted Functions ============\n', '\n', '    function transferOtherOwnership(\n', '        address _targetContract,\n', '        address _newOwner\n', '    )\n', '        external\n', '        onlyOwner\n', '    {\n', '        Ownable ownableContract = Ownable(_targetContract);\n', '\n', '        require(\n', '            ownableContract.owner() == address(this),\n', '            "ArcxTokenV2: this contract is not the owner of the target"\n', '        );\n', '\n', '        ownableContract.transferOwnership(_newOwner);\n', '\n', '        emit OtherOwnershipTransfered(\n', '            _targetContract,\n', '            _newOwner\n', '        );\n', '    }\n', '\n', '    function updatePauseOperator(\n', '        address _newPauseOperator\n', '    )\n', '        external\n', '        onlyOwner\n', '    {\n', '        pauseOperator = _newPauseOperator;\n', '\n', '        emit PauseOperatorUpdated(_newPauseOperator);\n', '    }\n', '\n', '    function setPause(\n', '        bool _pauseStatus\n', '    )\n', '        external\n', '    {\n', '        require(\n', '            msg.sender == pauseOperator,\n', '            "ArcxTokenV2: caller is not pause operator"\n', '        );\n', '\n', '        isPaused = _pauseStatus;\n', '\n', '        emit PauseStatusUpdated(_pauseStatus);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '/**\n', ' * @dev Contract module which provides a basic access control mechanism, where\n', ' * there is an account (an owner) that can be granted exclusive access to\n', ' * specific functions.\n', ' *\n', ' * By default, the owner account will be the one that deploys the contract. This\n', ' * can later be changed with {transferOwnership}.\n', ' *\n', ' * This module is used through inheritance. It will make available the modifier\n', ' * `onlyOwner`, which can be applied to your functions to restrict their use to\n', ' * the owner.\n', ' */\n', 'contract Ownable {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        _owner = msg.sender;\n', '        emit OwnershipTransferred(address(0), msg.sender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == msg.sender, "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    /**\n', '     * @dev Leaves the contract without owner. It will not be possible to call\n', '     * `onlyOwner` functions anymore. Can only be called by the current owner.\n', '     *\n', '     * NOTE: Renouncing ownership will leave the contract without an owner,\n', '     * thereby removing any functionality that is only available to the owner.\n', '     */\n', '    function renounceOwnership() public onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    /**\n', '     * @dev Transfers ownership of the contract to a new account (`newOwner`).\n', '     * Can only be called by the current owner.\n', '     */\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: GPL-3.0-or-later\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', 'import {IERC20} from "../token/IERC20.sol";\n', '\n', '// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false\n', 'library SafeERC20 {\n', '    function safeApprove(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('approve(address,uint256)')));\n", '        /* solium-disable-next-line */\n', '        (bool success, bytes memory data) = address(token).call(\n', '            abi.encodeWithSelector(0x095ea7b3, to, value)\n', '        );\n', '\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', '            "SafeERC20: APPROVE_FAILED"\n', '        );\n', '    }\n', '\n', '    function safeTransfer(\n', '        IERC20 token,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('transfer(address,uint256)')));\n", '        /* solium-disable-next-line */\n', '        (bool success, bytes memory data) = address(token).call(\n', '            abi.encodeWithSelector(0xa9059cbb, to, value)\n', '        );\n', '\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', '            "SafeERC20: TRANSFER_FAILED"\n', '        );\n', '    }\n', '\n', '    function safeTransferFrom(\n', '        IERC20 token,\n', '        address from,\n', '        address to,\n', '        uint256 value\n', '    ) internal {\n', "        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));\n", '        /* solium-disable-next-line */\n', '        (bool success, bytes memory data) = address(token).call(\n', '            abi.encodeWithSelector(\n', '                0x23b872dd,\n', '                from,\n', '                to,\n', '                value\n', '            )\n', '        );\n', '\n', '        require(\n', '            success && (data.length == 0 || abi.decode(data, (bool))),\n', '            "SafeERC20: TRANSFER_FROM_FAILED"\n', '        );\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', '/**\n', ' * @dev Interface of the ERC20 standard as defined in the EIP.\n', ' */\n', 'interface IERC20 {\n', '    /**\n', '     * @dev Returns the amount of tokens in existence.\n', '     */\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    /**\n', '     * @dev Returns the amount of tokens owned by `account`.\n', '     */\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    /**\n', "     * @dev Moves `amount` tokens from the caller's account to `recipient`.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transfer(\n', '        address recipient,\n', '        uint256 amount\n', '    )\n', '        external\n', '        returns (bool);\n', '\n', '    /**\n', '     * @dev Returns the remaining number of tokens that `spender` will be\n', '     * allowed to spend on behalf of `owner` through {transferFrom}. This is\n', '     * zero by default.\n', '     *\n', '     * This value changes when {approve} or {transferFrom} are called.\n', '     */\n', '    function allowance(\n', '        address owner,\n', '        address spender\n', '    )\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    /**\n', "     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.\n", '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * IMPORTANT: Beware that changing an allowance with this method brings the risk\n', '     * that someone may use both the old and the new allowance by unfortunate\n', '     * transaction ordering. One possible solution to mitigate this race\n', "     * condition is to first reduce the spender's allowance to 0 and set the\n", '     * desired value afterwards:\n', '     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729\n', '     *\n', '     * Emits an {Approval} event.\n', '     */\n', '    function approve(\n', '        address spender,\n', '        uint256 amount\n', '    )\n', '        external\n', '        returns (bool);\n', '\n', '    /**\n', '     * @dev Moves `amount` tokens from `sender` to `recipient` using the\n', "     * allowance mechanism. `amount` is then deducted from the caller's\n", '     * allowance.\n', '     *\n', '     * Returns a boolean value indicating whether the operation succeeded.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    )\n', '        external\n', '        returns (bool);\n', '\n', '    /**\n', '     * @dev Emitted when `value` tokens are moved from one account (`from`) to\n', '     * another (`to`).\n', '     *\n', '     * Note that `value` may be zero.\n', '     */\n', '    event Transfer(\n', '        address indexed from,\n', '        address indexed to,\n', '        uint256 value\n', '    );\n', '\n', '    /**\n', '     * @dev Emitted when the allowance of a `spender` for an `owner` is set by\n', '     * a call to {approve}. `value` is the new allowance.\n', '     */\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '\n', '        require(b > 0, "SafeMath: division by zero");\n', '        uint256 c = a / b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        require(b <= a, "SafeMath: subtraction overflow");\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.16;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'interface IMintableToken {\n', '\n', '    function mint(\n', '        address to,\n', '        uint256 value\n', '    )\n', '        external;\n', '\n', '    function burn(\n', '        address to,\n', '        uint256 value\n', '    )\n', '        external;\n', '\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', 'import {SafeMath} from "../lib/SafeMath.sol";\n', '\n', 'import {IERC20} from "./IERC20.sol";\n', 'import {Permittable} from "./Permittable.sol";\n', '\n', '/**\n', ' * @title ERC20 Token\n', ' *\n', ' * Basic ERC20 Implementation\n', ' */\n', 'contract BaseERC20 is IERC20, Permittable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint8   private _decimals;\n', '    uint256 private _totalSupply;\n', '\n', '    string  internal _name;\n', '    string  internal _symbol;\n', '\n', '    /**\n', '     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with\n', '     * a default value of 18.\n', '     *\n', '     * All three of these values are immutable: they can only be set once during\n', '     * construction.\n', '     */\n', '    constructor (\n', '        string memory name,\n', '        string memory symbol,\n', '        uint8         decimals\n', '    )\n', '        public\n', '        Permittable(name, "1")\n', '    {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name()\n', '        public\n', '        view\n', '        returns (string memory)\n', '    {\n', '        return _name;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the symbol of the token, usually a shorter version of the\n', '     * name.\n', '     */\n', '    function symbol()\n', '        public\n', '        view\n', '        returns (string memory)\n', '    {\n', '        return _symbol;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the number of decimals used to get its user representation.\n', '     * For example, if `decimals` equals `2`, a balance of `505` tokens should\n', '     * be displayed to a user as `5,05` (`505 / 10 ** 2`).\n', '     *\n', '     * Tokens usually opt for a value of 18, imitating the relationship between\n', '     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is\n', '     * called.\n', '     *\n', '     * NOTE: This information is only used for _display_ purposes: it in\n', '     * no way affects any of the arithmetic of the contract, including\n', '     * {IERC20-balanceOf} and {IERC20-transfer}.\n', '     */\n', '    function decimals()\n', '        public\n', '        view\n', '        returns (uint8)\n', '    {\n', '        return _decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-totalSupply}.\n', '     */\n', '    function totalSupply()\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-balanceOf}.\n', '     */\n', '    function balanceOf(\n', '        address account\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _balances[account];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transfer}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `recipient` cannot be the zero address.\n', '     * - the caller must have a balance of at least `amount`.\n', '     */\n', '    function transfer(\n', '        address recipient,\n', '        uint256 amount\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        _transfer(msg.sender, recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-allowance}.\n', '     */\n', '    function allowance(\n', '        address owner,\n', '        address spender\n', '    )\n', '        public\n', '        view\n', '        returns (uint256)\n', '    {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-approve}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function approve(\n', '        address spender,\n', '        uint256 amount\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        _approve(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transferFrom}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance. This is not\n', '     * required by the EIP. See the note at the beginning of {ERC20};\n', '     *\n', '     * Requirements:\n', '     * - `sender` and `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', "     * - the caller must have allowance for ``sender``'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    )\n', '        public\n', '        returns (bool)\n', '    {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(\n', '            sender,\n', '            msg.sender,\n', '            _allowances[sender][msg.sender].sub(amount)\n', '        );\n', '\n', '        return true;\n', '    }\n', '\n', '    /**\n', '    * @dev Approve by signature.\n', '    *\n', "    * Adapted from Uniswap's UniswapV2ERC20 and MakerDAO's Dai contracts:\n", '    * https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol\n', '    * https://github.com/makerdao/dss/blob/master/src/dai.sol\n', '    */\n', '    function permit(\n', '        address owner,\n', '        address spender,\n', '        uint256 value,\n', '        uint256 deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    )\n', '        public\n', '    {\n', '        _permit(\n', '            owner,\n', '            spender,\n', '            value,\n', '            deadline,\n', '            v,\n', '            r,\n', '            s\n', '        );\n', '        _approve(owner, spender, value);\n', '    }\n', '\n', '    /**\n', '     * @dev Moves tokens `amount` from `sender` to `recipient`.\n', '     *\n', '     * This is internal function is equivalent to {transfer}, and can be used to\n', '     * e.g. implement automatic token fees, slashing mechanisms, etc.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` cannot be the zero address.\n', '     * - `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', '     */\n', '    function _transfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    )\n', '        internal\n', '    {\n', '        require(\n', '            sender != address(0),\n', '            "ERC20: transfer from the zero address"\n', '        );\n', '\n', '        require(\n', '            recipient != address(0),\n', '            "ERC20: transfer to the zero address"\n', '        );\n', '\n', '        _balances[sender] = _balances[sender].sub(amount);\n', '\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     *\n', '     * Emits a {Transfer} event with `from` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     */\n', '    function _mint(\n', '        address account,\n', '        uint256 amount\n', '    )\n', '        internal\n', '    {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     *\n', '     * Emits a {Transfer} event with `to` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     * - `account` must have at least `amount` tokens.\n', '     */\n', '    function _burn(\n', '        address account,\n', '        uint256 amount\n', '    )\n', '        internal\n', '    {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _balances[account] = _balances[account].sub(amount);\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.\n', '     *\n', '     * This internal function is equivalent to `approve`, and can be used to\n', '     * e.g. set automatic allowances for certain subsystems, etc.\n', '     *\n', '     * Emits an {Approval} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `owner` cannot be the zero address.\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    )\n', '        internal\n', '    {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.5.16;\n', '\n', 'contract Permittable {\n', '\n', '    /* ============ Variables ============ */\n', '\n', '    bytes32 public DOMAIN_SEPARATOR;\n', '\n', '    mapping (address => uint256) public permitNonces;\n', '\n', '    /* ============ Constants ============ */\n', '\n', '    // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");\n', '    /* solium-disable-next-line */\n', '    bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;\n', '\n', '    /* ============ Constructor ============ */\n', '\n', '    constructor(\n', '        string memory name,\n', '        string memory version\n', '    )\n', '        public\n', '    {\n', '        DOMAIN_SEPARATOR = _initDomainSeparator(name, version);\n', '    }\n', '\n', '    /**\n', '     * @dev Initializes EIP712 DOMAIN_SEPARATOR based on the current contract and chain ID.\n', '     */\n', '    function _initDomainSeparator(\n', '        string memory name,\n', '        string memory version\n', '    )\n', '        internal\n', '        view\n', '        returns (bytes32)\n', '    {\n', '        uint256 chainID;\n', '        /* solium-disable-next-line */\n', '        assembly {\n', '            chainID := chainid()\n', '        }\n', '\n', '        return keccak256(\n', '            abi.encode(\n', '                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),\n', '                keccak256(bytes(name)),\n', '                keccak256(bytes(version)),\n', '                chainID,\n', '                address(this)\n', '            )\n', '        );\n', '    }\n', '\n', '    /**\n', '    * @dev Approve by signature.\n', '    *\n', "    * Adapted from Uniswap's UniswapV2ERC20 and MakerDAO's Dai contracts:\n", '    * https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol\n', '    * https://github.com/makerdao/dss/blob/master/src/dai.sol\n', '    */\n', '    function _permit(\n', '        address owner,\n', '        address spender,\n', '        uint256 value,\n', '        uint256 deadline,\n', '        uint8 v,\n', '        bytes32 r,\n', '        bytes32 s\n', '    )\n', '        internal\n', '    {\n', '\n', '        require(\n', '            deadline == 0 || deadline >= block.timestamp,\n', '            "Permittable: Permit expired"\n', '        );\n', '\n', '        require(\n', '            spender != address(0),\n', '            "Permittable: spender cannot be 0x0"\n', '        );\n', '\n', '        require(\n', '            value > 0,\n', '            "Permittable: approval value must be greater than 0"\n', '        );\n', '\n', '        bytes32 digest = keccak256(\n', '            abi.encodePacked(\n', '                "\\x19\\x01",\n', '                DOMAIN_SEPARATOR,\n', '                keccak256(\n', '                    abi.encode(\n', '                    PERMIT_TYPEHASH,\n', '                    owner,\n', '                    spender,\n', '                    value,\n', '                    permitNonces[owner]++,\n', '                    deadline\n', '                )\n', '            )\n', '        ));\n', '\n', '        address recoveredAddress = ecrecover(\n', '            digest,\n', '            v,\n', '            r,\n', '            s\n', '        );\n', '\n', '        require(\n', '            recoveredAddress != address(0) && owner == recoveredAddress,\n', '            "Permittable: Signature invalid"\n', '        );\n', '\n', '    }\n', '\n', '}\n', '\n', '{\n', '  "metadata": {\n', '    "useLiteralContent": true\n', '  },\n', '  "optimizer": {\n', '    "enabled": true,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  }\n', '}']