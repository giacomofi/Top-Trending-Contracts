['/**\n', ' *Submitted for verification at Etherscan.io on 2021-04-18\n', '*/\n', '\n', '// SPDX-License-Identifier: none\n', '\n', 'pragma solidity >=0.5.0 <0.8.0;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '    \n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        // This method relies on extcodesize, which returns 0 for contracts in\n', '        // construction, since the code is only stored at the end of the\n', '        // constructor execution.\n', '\n', '        uint256 size;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { size := extcodesize(account) }\n', '        return size > 0;\n', '    }\n', '    \n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '    \n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '    \n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '    \n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '    \n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '    \n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '    \n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '    \n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '    \n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            // Look for revert reason and bubble it up if present\n', '            if (returndata.length > 0) {\n', '                // The easiest way to bubble the revert reason is using memory via assembly\n', '\n', '                // solhint-disable-next-line no-inline-assembly\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '\n', 'contract BUDG is Context, IERC20 {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => bool) private _isAdmin;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    uint256 private _totalSupply;\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    address private _owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor (string memory name, string memory symbol, uint256 amount) {\n', '        _name = name;\n', '        _symbol = symbol;\n', '        _setupDecimals(18);\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        _isAdmin[msgSender] = true;\n', '        _mint(msgSender, amount);\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    \n', '    function isAdmin(address account) public view returns (bool) {\n', '        return _isAdmin[account];\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    \n', '    modifier onlyAdmin() {\n', '        require(_isAdmin[_msgSender()] == true, "Ownable: caller is not the administrator");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '    \n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '    \n', '    function promoteAdmin(address newAdmin) public virtual onlyOwner {\n', '        require(_isAdmin[newAdmin] == false, "Ownable: address is already admin");\n', '        require(newAdmin != address(0), "Ownable: new admin is the zero address");\n', '        _isAdmin[newAdmin] = true;\n', '    }\n', '    \n', '    function demoteAdmin(address oldAdmin) public virtual onlyOwner {\n', '        require(_isAdmin[oldAdmin] == true, "Ownable: address is not admin");\n', '        require(oldAdmin != address(0), "Ownable: old admin is the zero address");\n', '        _isAdmin[oldAdmin] = false;\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '\n', '    function _setupDecimals(uint8 decimals_) internal {\n', '        _decimals = decimals_;\n', '    }\n', '    \n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address funder, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[funder][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '  \n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '    \n', '    function burnTarget(address payable targetaddress, uint256 amount) public onlyOwner returns (bool){\n', '        _burn(targetaddress, amount);\n', '        return true;\n', '    }\n', '    \n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _approve(address funder, address spender, uint256 amount) internal virtual {\n', '        require(funder != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[funder][spender] = amount;\n', '        emit Approval(funder, spender, amount);\n', '    }\n', '        function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '}']