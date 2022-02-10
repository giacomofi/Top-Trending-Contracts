['// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity >=0.6.2;\n', '\n', 'import "./Context.sol";\n', 'import "./IERC20.sol";\n', 'import "./Ownable.sol";\n', 'import "./SafeMath.sol";\n', 'import "./Address.sol";\n', '\n', 'contract GRUG is Context, IERC20, Ownable {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '\n', '    mapping (address => uint256) private _rOwned;\n', '    mapping (address => uint256) private _tOwned;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '\n', '    mapping (address => bool) private _isExcluded;\n', '    address[] private _excluded;\n', '   \n', '    uint256 private constant MAX = ~uint256(0);\n', '    uint256 private _tTotal = 100000000 * 10**9;\n', '    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n', '    uint256 private _tFeeTotal;\n', '    uint256 private _tBurnTotal;\n', '\n', "    string private _name = 'GRUG';\n", "    string private _symbol = 'GRUG';\n", '    uint8 private _decimals = 9;\n', '    \n', '    uint256 private _taxFee = 5;\n', '    uint256 private _burnFee = 5;\n', '    uint256 private _maxTxAmount = 100000000e9;\n', '\n', '    constructor () public {\n', '        _rOwned[_msgSender()] = _rTotal;\n', '        emit Transfer(address(0), _msgSender(), _tTotal);\n', '    }\n', '\n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _tTotal;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        if (_isExcluded[account]) return _tOwned[account];\n', '        return tokenFromReflection(_rOwned[account]);\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    function isExcluded(address account) public view returns (bool) {\n', '        return _isExcluded[account];\n', '    }\n', '\n', '    function totalFees() public view returns (uint256) {\n', '        return _tFeeTotal;\n', '    }\n', '    \n', '    function totalBurn() public view returns (uint256) {\n', '        return _tBurnTotal;\n', '    }\n', '\n', '    function deliver(uint256 tAmount) public {\n', '        address sender = _msgSender();\n', '        require(!_isExcluded[sender], "Excluded addresses cannot call this function");\n', '        (uint256 rAmount,,,,,) = _getValues(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rTotal = _rTotal.sub(rAmount);\n', '        _tFeeTotal = _tFeeTotal.add(tAmount);\n', '    }\n', '\n', '    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {\n', '        require(tAmount <= _tTotal, "Amount must be less than supply");\n', '        if (!deductTransferFee) {\n', '            (uint256 rAmount,,,,,) = _getValues(tAmount);\n', '            return rAmount;\n', '        } else {\n', '            (,uint256 rTransferAmount,,,,) = _getValues(tAmount);\n', '            return rTransferAmount;\n', '        }\n', '    }\n', '\n', '    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {\n', '        require(rAmount <= _rTotal, "Amount must be less than total reflections");\n', '        uint256 currentRate =  _getRate();\n', '        return rAmount.div(currentRate);\n', '    }\n', '\n', '    function excludeAccount(address account) external onlyOwner() {\n', "        require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');\n", '        require(!_isExcluded[account], "Account is already excluded");\n', '        if(_rOwned[account] > 0) {\n', '            _tOwned[account] = tokenFromReflection(_rOwned[account]);\n', '        }\n', '        _isExcluded[account] = true;\n', '        _excluded.push(account);\n', '    }\n', '\n', '    function includeAccount(address account) external onlyOwner() {\n', '        require(_isExcluded[account], "Account is already excluded");\n', '        for (uint256 i = 0; i < _excluded.length; i++) {\n', '            if (_excluded[i] == account) {\n', '                _excluded[i] = _excluded[_excluded.length - 1];\n', '                _tOwned[account] = 0;\n', '                _isExcluded[account] = false;\n', '                _excluded.pop();\n', '                break;\n', '            }\n', '        }\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) private {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _transfer(address sender, address recipient, uint256 amount) private {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '        require(amount > 0, "Transfer amount must be greater than zero");\n', '        \n', '        if(sender != owner() && recipient != owner())\n', '            require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");\n', '        \n', '        if (_isExcluded[sender] && !_isExcluded[recipient]) {\n', '            _transferFromExcluded(sender, recipient, amount);\n', '        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {\n', '            _transferToExcluded(sender, recipient, amount);\n', '        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {\n', '            _transferStandard(sender, recipient, amount);\n', '        } else if (_isExcluded[sender] && _isExcluded[recipient]) {\n', '            _transferBothExcluded(sender, recipient, amount);\n', '        } else {\n', '            _transferStandard(sender, recipient, amount);\n', '        }\n', '    }\n', '\n', '    function _transferStandard(address sender, address recipient, uint256 tAmount) private {\n', '        uint256 currentRate =  _getRate();\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);\n', '        uint256 rBurn =  tBurn.mul(currentRate);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       \n', '        _reflectFee(rFee, rBurn, tFee, tBurn);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        uint256 currentRate =  _getRate();\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);\n', '        uint256 rBurn =  tBurn.mul(currentRate);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           \n', '        _reflectFee(rFee, rBurn, tFee, tBurn);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        uint256 currentRate =  _getRate();\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);\n', '        uint256 rBurn =  tBurn.mul(currentRate);\n', '        _tOwned[sender] = _tOwned[sender].sub(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   \n', '        _reflectFee(rFee, rBurn, tFee, tBurn);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        uint256 currentRate =  _getRate();\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);\n', '        uint256 rBurn =  tBurn.mul(currentRate);\n', '        _tOwned[sender] = _tOwned[sender].sub(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        \n', '        _reflectFee(rFee, rBurn, tFee, tBurn);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {\n', '        _rTotal = _rTotal.sub(rFee).sub(rBurn);\n', '        _tFeeTotal = _tFeeTotal.add(tFee);\n', '        _tBurnTotal = _tBurnTotal.add(tBurn);\n', '        _tTotal = _tTotal.sub(tBurn);\n', '    }\n', '\n', '    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {\n', '        (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _taxFee, _burnFee);\n', '        uint256 currentRate =  _getRate();\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);\n', '        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);\n', '    }\n', '\n', '    function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {\n', '        uint256 tFee = tAmount.mul(taxFee).div(100);\n', '        uint256 tBurn = tAmount.mul(burnFee).div(100);\n', '        uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);\n', '        return (tTransferAmount, tFee, tBurn);\n', '    }\n', '\n', '    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {\n', '        uint256 rAmount = tAmount.mul(currentRate);\n', '        uint256 rFee = tFee.mul(currentRate);\n', '        uint256 rBurn = tBurn.mul(currentRate);\n', '        uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);\n', '        return (rAmount, rTransferAmount, rFee);\n', '    }\n', '\n', '    function _getRate() private view returns(uint256) {\n', '        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n', '        return rSupply.div(tSupply);\n', '    }\n', '\n', '    function _getCurrentSupply() private view returns(uint256, uint256) {\n', '        uint256 rSupply = _rTotal;\n', '        uint256 tSupply = _tTotal;      \n', '        for (uint256 i = 0; i < _excluded.length; i++) {\n', '            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);\n', '            rSupply = rSupply.sub(_rOwned[_excluded[i]]);\n', '            tSupply = tSupply.sub(_tOwned[_excluded[i]]);\n', '        }\n', '        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);\n', '        return (rSupply, tSupply);\n', '    }\n', '    \n', '    function _getTaxFee() private view returns(uint256) {\n', '        return _taxFee;\n', '    }\n', '\n', '    function _getMaxTxAmount() private view returns(uint256) {\n', '        return _maxTxAmount;\n', '    }\n', '    \n', '}']