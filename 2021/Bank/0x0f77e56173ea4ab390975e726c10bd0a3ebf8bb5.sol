['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-12\n', '*/\n', '\n', '// SPDX-License-Identifier: GPL-3.0-only\n', '\n', 'pragma solidity ^0.8.0;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', 'interface IERC20Metadata is IERC20 {\n', '    function name() external view returns (string memory);\n', '    function symbol() external view returns (string memory);\n', '    function decimals() external view returns (uint8);\n', '}\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {return msg.sender;}\n', '    function _msgData() internal view virtual returns (bytes calldata) {this; return msg.data;}\n', '}\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        unchecked { require(b <= a, errorMessage); return a - b; }\n', '    }\n', '}\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) { uint256 size; assembly { size := extcodesize(account) } return size > 0;}\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");(bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {return functionCall(target, data, "Address: low-level call failed");}\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {return functionCallWithValue(target, data, 0, errorMessage);}\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {return functionCallWithValue(target, data, value, "Address: low-level call with value failed");}\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        require(isContract(target), "Address: call to non-contract");\n', '        (bool success, bytes memory returndata) = target.call{ value: value }(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {\n', '        return functionStaticCall(target, data, "Address: low-level static call failed");\n', '    }\n', '    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {\n', '        require(isContract(target), "Address: static call to non-contract");\n', '        (bool success, bytes memory returndata) = target.staticcall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionDelegateCall(target, data, "Address: low-level delegate call failed");\n', '    }\n', '    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        require(isContract(target), "Address: delegate call to non-contract");\n', '        (bool success, bytes memory returndata) = target.delegatecall(data);\n', '        return _verifyCallResult(success, returndata, errorMessage);\n', '    }\n', '    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {\n', '        if (success) { return returndata; } else {\n', '            if (returndata.length > 0) {\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {revert(errorMessage);}\n', '        }\n', '    }\n', '}\n', 'abstract contract Ownable is Context {\n', '    address private _owner;\n', '    address private _previousOwner;\n', '    uint256 private _lockTime;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '    function getUnlockTime() public view returns (uint256) {\n', '        return _lockTime;\n', '    }\n', '    function lock(uint256 time) public virtual onlyOwner {\n', '        _previousOwner = _owner;\n', '        _owner = address(0);\n', '        _lockTime = block.timestamp + time;\n', '        emit OwnershipTransferred(_owner, address(0));\n', '    }\n', '    function unlock() public virtual {\n', '        require(_previousOwner == msg.sender, "Only the previous owner can unlock onwership");\n', '        require(block.timestamp > _lockTime , "The contract is still locked");\n', '        emit OwnershipTransferred(_owner, _previousOwner);\n', '        _owner = _previousOwner;\n', '    }\n', '}\n', 'abstract contract Manageable is Context {\n', '    address private _manager;\n', '    event ManagementTransferred(address indexed previousManager, address indexed newManager);\n', '    constructor(){\n', '        address msgSender = _msgSender();\n', '        _manager = msgSender;\n', '        emit ManagementTransferred(address(0), msgSender);\n', '    }\n', '    function manager() public view returns(address){ return _manager; }\n', '    modifier onlyManager(){\n', '        require(_manager == _msgSender(), "Manageable: caller is not the manager");\n', '        _;\n', '    }\n', '    function transferManagement(address newManager) external virtual onlyManager {\n', '        emit ManagementTransferred(_manager, newManager);\n', '        _manager = newManager;\n', '    }\n', '}\n', '\n', 'contract DPInu is Context, IERC20, Ownable {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    mapping (address => uint256) private _rOwned;\n', '    mapping (address => uint256) private _tOwned;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    mapping (address => bool) private _isExcluded;\n', '    address[] private _excluded;\n', '\n', '\n', '    //Tokenomics\n', '    uint256 private constant MAX = ~uint256(0);\n', '\tuint256 private constant _tTotal = 5000 * 10**13 * 10**9;\n', '    uint256 private _rTotal;\n', '    uint256 private _tFeeTotal;\n', '\n', '    string private _name;\n', '    string private _symbol;\n', '    uint8 private _decimals;\n', '    address private constant _teamAddress = 0xe425c24019d112ef3a26Da03fe04d895A95312d6;\n', '    uint256 private _teamFeeTotal;\n', '\n', '   constructor ()  {\n', '       \n', '        _rTotal = (MAX - (MAX % _tTotal));\n', "        _name = 'Dump&Pump Inu';\n", "        _symbol = 'DPInu';\n", '        _decimals = 13;\n', '\n', '        _rOwned[_msgSender()] = _rTotal;\n', '        emit Transfer(address(0), _msgSender(), _tTotal);\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public pure override returns (uint256) {\n', '        return _tTotal;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        if (_isExcluded[account]) return _tOwned[account];\n', '        return tokenFromReflection(_rOwned[account]);\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    function isExcluded(address account) public view returns (bool) {\n', '        return _isExcluded[account];\n', '    }\n', '\n', '    function totalFees() public view returns (uint256) {\n', '        return _tFeeTotal;\n', '    }\n', '\n', '    function reflect(uint256 tAmount) public {\n', '        address sender = _msgSender();\n', '        require(!_isExcluded[sender], "Excluded addresses cannot call this function");\n', '        (uint256 rAmount,,,) = _getValues(tAmount, 6);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rTotal = _rTotal.sub(rAmount);\n', '        _tFeeTotal = _tFeeTotal.add(tAmount);\n', '    }\n', '    \n', '    //fees get degrees (reflection fee and team fee)\n', '\n', '    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {\n', '        require(tAmount <= _tTotal, "Amount must be less than supply");\n', '        if (!deductTransferFee) {\n', '            (uint256 rAmount,,,) = _getValues(tAmount, 3);\n', '            return rAmount;\n', '        } else {\n', '            (,uint256 rTransferAmount,,) = _getValues(tAmount, 3);\n', '            return rTransferAmount;\n', '        }\n', '    }\n', '\n', '    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {\n', '        require(rAmount <= _rTotal, "Amount must be less than total reflections");\n', '        uint256 currentRate =  _getRate();\n', '        return rAmount.div(currentRate);\n', '    }\n', '\n', '\n', '    function _approve(address owner, address spender, uint256 amount) private {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) private {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        require(amount > 0, "Transfer amount must be greater than zero");\n', '\n', '        uint256 txFee = 3;\n', '        uint256 teamFee = 3;\n', '        uint256 totalFeePercentage = txFee + teamFee;\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 currentRate) = _getValues(amount, totalFeePercentage);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);\n', '\n', '        if (_isExcluded[sender]) { _tOwned[sender] = _tOwned[sender].sub(amount); }\n', '        if (_isExcluded[recipient]) { _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount); }\n', '\n', '        uint256 tFee = amount.mul(txFee).div(100);\n', '        uint256 rFee = tFee.mul(currentRate);\n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '\n', '        uint256 tteam = amount.mul(teamFee).div(100);\n', '        uint256 rteam = tteam.mul(currentRate);\n', '        _teamTokens(address(this), tteam, rteam);\n', '    }\n', '\n', '    function _reflectFee(uint256 rFee, uint256 tFee) private {\n', '        _rTotal = _rTotal.sub(rFee);\n', '        _tFeeTotal = _tFeeTotal.add(tFee);\n', '    }\n', '\n', '    function _getValues(uint256 tAmount, uint256 totalFeePercentage) private view returns (uint256, uint256, uint256, uint256) {\n', '        uint256 currentRate =  _getRate();\n', '\n', '        uint256 totalFee = tAmount.mul(totalFeePercentage).div(100);\n', '        uint256 tTransferAmount = tAmount.sub(totalFee);\n', '        \n', '        uint256 rAmount = tAmount.mul(currentRate);\n', '        uint256 rFee = totalFee.mul(currentRate);\n', '        uint256 rTransferAmount = rAmount.sub(rFee);\n', '        return (rAmount, rTransferAmount, tTransferAmount, currentRate);\n', '    }\n', '\n', '    function _getRate() private view returns(uint256) {\n', '        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n', '        return rSupply.div(tSupply);\n', '    }\n', '\n', '    function _getCurrentSupply() private view returns(uint256, uint256) {\n', '        uint256 rSupply = _rTotal;\n', '        uint256 tSupply = _tTotal;      \n', '        for (uint256 i = 0; i < _excluded.length; i++) {\n', '            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);\n', '            rSupply = rSupply.sub(_rOwned[_excluded[i]]);\n', '            tSupply = tSupply.sub(_tOwned[_excluded[i]]);\n', '        }\n', '        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);\n', '        return (rSupply, tSupply);\n', '    }\n', '\n', '    //Owner\n', '\n', '    function excludeAccount(address account) external onlyOwner() {\n', '        require(!_isExcluded[account], "Account is already excluded");\n', '        if(_rOwned[account] > 0) {\n', '            _tOwned[account] = tokenFromReflection(_rOwned[account]);\n', '        }\n', '        _isExcluded[account] = true;\n', '        _excluded.push(account);\n', '    }\n', '\n', '    function includeAccount(address account) external onlyOwner() {\n', '        require(_isExcluded[account], "Account is already excluded");\n', '        for (uint256 i = 0; i < _excluded.length; i++) {\n', '            if (_excluded[i] == account) {\n', '                _excluded[i] = _excluded[_excluded.length - 1];\n', '                _tOwned[account] = 0;\n', '                _isExcluded[account] = false;\n', '                _excluded.pop();\n', '                break;\n', '            }\n', '        }\n', '    }\n', '\n', '    //For the team\n', '\n', '    function _teamTokens(address sender, uint256 tteam, uint256 rteam) internal {\n', '        _rOwned[_teamAddress] = _rOwned[_teamAddress].add(rteam);\n', '        if (_isExcluded[_teamAddress])\n', '            _tOwned[_teamAddress] = _tOwned[_teamAddress].add(tteam);\n', '\n', '        emit Transfer(sender, _teamAddress, tteam);\n', '        _teamFeeTotal = _teamFeeTotal.add(tteam);\n', '    }\n', '}']