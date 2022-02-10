['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-03\n', '*/\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', ' \n', 'pragma solidity ^0.8.4;\n', ' \n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return payable(msg.sender);\n', '    }\n', ' \n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691\n', '        return msg.data;\n', '    }\n', '}\n', ' \n', ' \n', 'interface IERC20 {\n', ' \n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', ' \n', ' \n', '}\n', ' \n', 'library SafeMath {\n', ' \n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', ' \n', '        return c;\n', '    }\n', ' \n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', ' \n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', ' \n', '        return c;\n', '    }\n', ' \n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', ' \n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', ' \n', '        return c;\n', '    }\n', ' \n', ' \n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', ' \n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", ' \n', '        return c;\n', '    }\n', ' \n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', ' \n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', ' \n', 'library Address {\n', ' \n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', ' \n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', ' \n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', ' \n', ' \n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '      return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', ' \n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', ' \n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', ' \n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', ' \n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', ' \n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', ' \n', '            if (returndata.length > 0) {\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', ' \n', 'contract Ownable is Context {\n', '    address private _owner;\n', '    address private _previousOwner;\n', '    uint256 private _lockTime;\n', ' \n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', ' \n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', ' \n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }   \n', ' \n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', ' \n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', ' \n', '    function transferOwnership(address newOwner) public virtual onlyOwner {\n', '        require(newOwner != address(0), "Ownable: new owner is the zero address");\n', '        emit OwnershipTransferred(_owner, newOwner);\n', '        _owner = newOwner;\n', '    }\n', '}\n', ' \n', ' \n', 'contract Shelon is Context, IERC20, Ownable {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', ' \n', '    address public marketingAddress = 0xe084fA87fA39B6Decc715F81D2d53b5D8aab4FB0; // Marketing Address\n', '    address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;\n', '    mapping (address => uint256) private _rOwned;\n', '    mapping (address => uint256) private _tOwned;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', ' \n', '    mapping (address => bool) private _isExcludedFromFee;\n', ' \n', '    mapping (address => bool) private _isExcluded;\n', '    address[] private _excluded;\n', ' \n', '    uint256 private constant MAX = ~uint256(0);\n', '    uint256 private _tTotal = 1000000000 * 10**6 * 10**9;\n', '    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n', '    uint256 private _tFeeTotal;\n', ' \n', '    string private _name = "Shelon";\n', '    string private _symbol = "SHLN";\n', '    uint8 private _decimals = 9;\n', ' \n', ' \n', '    uint256 public _taxFee = 2;\n', '    uint256 private _previousTaxFee = _taxFee;\n', ' \n', '    uint256 public _marketingFee = 1;\n', '    uint256 private _previousMarketingFee = _marketingFee;\n', ' \n', '    uint256 public _burnFee = 3;\n', '    uint256 private _previousBurnFee = _burnFee;\n', ' \n', '    uint256 public _maxTxAmount = 3000000 * 10**6 * 10**9;\n', ' \n', ' \n', '    constructor () {\n', '        _rOwned[_msgSender()] = _rTotal;\n', ' \n', '        _isExcludedFromFee[owner()] = true;\n', '        _isExcludedFromFee[marketingAddress] = true;\n', '        _isExcludedFromFee[address(this)] = true;\n', ' \n', '        emit Transfer(address(0), _msgSender(), _tTotal);\n', '    }\n', ' \n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', ' \n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', ' \n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', ' \n', '    function totalSupply() public view override returns (uint256) {\n', '        return _tTotal;\n', '    }\n', ' \n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        if (_isExcluded[account]) return _tOwned[account];\n', '        return tokenFromReflection(_rOwned[account]);\n', '    }\n', ' \n', '    function transfer(address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', ' \n', '    function allowance(address owner, address spender) public view override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', ' \n', '    function approve(address spender, uint256 amount) public override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', ' \n', '    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', ' \n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', ' \n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', ' \n', '    function isExcludedFromReward(address account) public view returns (bool) {\n', '        return _isExcluded[account];\n', '    }\n', ' \n', '    function totalFees() public view returns (uint256) {\n', '        return _tFeeTotal;\n', '    }\n', ' \n', ' \n', ' \n', '    function deliver(uint256 tAmount) public {\n', '        address sender = _msgSender();\n', '        require(!_isExcluded[sender], "Excluded addresses cannot call this function");\n', '        (uint256 rAmount,,,,,) = _getValues(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rTotal = _rTotal.sub(rAmount);\n', '        _tFeeTotal = _tFeeTotal.add(tAmount);\n', '    }\n', ' \n', ' \n', '    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {\n', '        require(tAmount <= _tTotal, "Amount must be less than supply");\n', '        if (!deductTransferFee) {\n', '            (uint256 rAmount,,,,,) = _getValues(tAmount);\n', '            return rAmount;\n', '        } else {\n', '            (,uint256 rTransferAmount,,,,) = _getValues(tAmount);\n', '            return rTransferAmount;\n', '        }\n', '    }\n', ' \n', '    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {\n', '        require(rAmount <= _rTotal, "Amount must be less than total reflections");\n', '        uint256 currentRate =  _getRate();\n', '        return rAmount.div(currentRate);\n', '    }\n', ' \n', '    function excludeFromReward(address account) public onlyOwner() {\n', ' \n', '        require(!_isExcluded[account], "Account is already excluded");\n', '        if(_rOwned[account] > 0) {\n', '            _tOwned[account] = tokenFromReflection(_rOwned[account]);\n', '        }\n', '        _isExcluded[account] = true;\n', '        _excluded.push(account);\n', '    }\n', ' \n', '    function includeInReward(address account) external onlyOwner() {\n', '        require(_isExcluded[account], "Account is already excluded");\n', '        for (uint256 i = 0; i < _excluded.length; i++) {\n', '            if (_excluded[i] == account) {\n', '                _excluded[i] = _excluded[_excluded.length - 1];\n', '                _tOwned[account] = 0;\n', '                _isExcluded[account] = false;\n', '                _excluded.pop();\n', '                break;\n', '            }\n', '        }\n', '    }\n', ' \n', '    function _approve(address owner, address spender, uint256 amount) private {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', ' \n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', ' \n', '    function _transfer(\n', '        address from,\n', '        address to,\n', '        uint256 amount\n', '    ) private {\n', '        require(from != address(0), "ERC20: transfer from the zero address");\n', '        require(to != address(0), "ERC20: transfer to the zero address");\n', '        require(amount > 0, "Transfer amount must be greater than zero");\n', '        if(from != owner() && to != owner()) {\n', '            require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");\n', '        }\n', ' \n', '        bool takeFee = true;\n', ' \n', '        //if any account belongs to _isExcludedFromFee account then remove the fee\n', '        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){\n', '            takeFee = false;\n', '        }\n', ' \n', '        _tokenTransfer(from,to,amount,takeFee);\n', '    }\n', ' \n', ' \n', '    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {\n', '        if(!takeFee)\n', '            removeAllFee();\n', ' \n', '        uint256 burnAmt = amount.mul(_burnFee).div(100);\n', ' \n', '        if (_isExcluded[sender] && !_isExcluded[recipient]) {\n', '            _transferFromExcluded(sender, recipient, amount.sub(burnAmt));\n', '        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {\n', '            _transferToExcluded(sender, recipient, amount.sub(burnAmt));\n', '        } else if (_isExcluded[sender] && _isExcluded[recipient]) {\n', '            _transferBothExcluded(sender, recipient, amount.sub(burnAmt));\n', '        } else {\n', '            _transferStandard(sender, recipient, amount.sub(burnAmt));\n', '        }\n', ' \n', '        _taxFee = 0; _marketingFee = 0;\n', '        _transferStandard(sender, address(0), burnAmt);\n', '        _taxFee = _previousTaxFee; _marketingFee = _previousMarketingFee;\n', ' \n', '        if(!takeFee)\n', '            restoreAllFee();\n', '    }\n', ' \n', '    function _transferStandard(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);\n', '        _takeMarketing(tMarketing);\n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', ' \n', '    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);\n', '\t    _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           \n', '        _takeMarketing(tMarketing);\n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', ' \n', '    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);\n', '    \t_tOwned[sender] = _tOwned[sender].sub(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   \n', '        _takeMarketing(tMarketing);\n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', ' \n', '    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);\n', '    \t_tOwned[sender] = _tOwned[sender].sub(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        \n', '        _takeMarketing(tMarketing);\n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', ' \n', '    function _reflectFee(uint256 rFee, uint256 tFee) private {\n', '        _rTotal = _rTotal.sub(rFee);\n', '        _tFeeTotal = _tFeeTotal.add(tFee);\n', '    }\n', ' \n', '    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {\n', '        (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());\n', '        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);\n', '    }\n', ' \n', '    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {\n', '        uint256 tFee = calculateTaxFee(tAmount);\n', '        uint256 tMarketing = calculateMarketingFee(tAmount);\n', '        uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);\n', '        return (tTransferAmount, tFee, tMarketing);\n', '    }\n', ' \n', '    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {\n', '        uint256 rAmount = tAmount.mul(currentRate);\n', '        uint256 rFee = tFee.mul(currentRate);\n', '        uint256 rMarketing = tMarketing.mul(currentRate);\n', '        uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);\n', '        return (rAmount, rTransferAmount, rFee);\n', '    }\n', ' \n', '    function _getRate() private view returns(uint256) {\n', '        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n', '        return rSupply.div(tSupply);\n', '    }\n', ' \n', '    function _getCurrentSupply() private view returns(uint256, uint256) {\n', '        uint256 rSupply = _rTotal;\n', '        uint256 tSupply = _tTotal;      \n', '        for (uint256 i = 0; i < _excluded.length; i++) {\n', '            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);\n', '            rSupply = rSupply.sub(_rOwned[_excluded[i]]);\n', '            tSupply = tSupply.sub(_tOwned[_excluded[i]]);\n', '        }\n', '        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);\n', '        return (rSupply, tSupply);\n', '    }\n', ' \n', '    function _takeMarketing(uint256 tMarketing) private {\n', '        uint256 currentRate =  _getRate();\n', '        uint256 rMarketing = tMarketing.mul(currentRate);\n', '        _rOwned[marketingAddress] = _rOwned[marketingAddress].add(rMarketing);\n', '        if(_isExcluded[marketingAddress])\n', '            _tOwned[marketingAddress] = _tOwned[marketingAddress].add(tMarketing);\n', '    }\n', ' \n', '    function calculateTaxFee(uint256 _amount) private view returns (uint256) {\n', '        return _amount.mul(_taxFee).div(\n', '            10**2\n', '        );\n', '    }\n', ' \n', '    function calculateMarketingFee(uint256 _amount) private view returns (uint256) {\n', '        return _amount.mul(_marketingFee).div(\n', '            10**2\n', '        );\n', '    }\n', ' \n', '    function removeAllFee() private {\n', '        if(_taxFee == 0 && _marketingFee == 0 && _burnFee == 0) return;\n', ' \n', '        _previousTaxFee = _taxFee;\n', '        _previousMarketingFee = _marketingFee;\n', '        _previousBurnFee = _burnFee;\n', ' \n', '        _taxFee = 0;\n', '        _marketingFee = 0;\n', '        _burnFee = 0;\n', '    }\n', ' \n', '    function restoreAllFee() private {\n', '        _taxFee = _previousTaxFee;\n', '        _marketingFee = _previousMarketingFee;\n', '        _burnFee = _previousBurnFee;\n', '    }\n', ' \n', '    function isExcludedFromFee(address account) public view returns(bool) {\n', '        return _isExcludedFromFee[account];\n', '    }\n', ' \n', '    function excludeFromFee(address account) public onlyOwner {\n', '        _isExcludedFromFee[account] = true;\n', '    }\n', ' \n', '    function includeInFee(address account) public onlyOwner {\n', '        _isExcludedFromFee[account] = false;\n', '    }\n', ' \n', '    function setTaxFeePercent(uint256 taxFee) external onlyOwner() {\n', '        _taxFee = taxFee;\n', '    }\n', ' \n', '    function setBurnFee(uint256 burnFee) external onlyOwner{\n', '        _burnFee = burnFee;\n', '    }\n', ' \n', '    function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {\n', '        _maxTxAmount = maxTxAmount;\n', '    }\n', ' \n', '    function setMarketingAddress(address _marketingAddress) external onlyOwner() {\n', '        marketingAddress = _marketingAddress;\n', '    }\n', ' \n', ' \n', ' \n', '}']