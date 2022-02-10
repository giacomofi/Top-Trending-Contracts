['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-02\n', '*/\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '// \n', '// t.me/dogecoinpolytopiaERC\n', '//: Website coming soon \n', '//: DOGECOIN POLYTOPIA\n', '\n', 'pragma solidity ^0.6.12;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address payable) {\n', '        return msg.sender;\n', '    }\n', '\n', '    function _msgData() internal view virtual returns (bytes memory) {\n', '        this;\n', '        return msg.data;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'library Address {\n', '    function isContract(address account) internal view returns (bool) {\n', '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '            if (returndata.length > 0) {\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '    address private _previousOwner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () internal {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '}  \n', '\n', 'interface IUniswapV2Factory {\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '}\n', '\n', 'interface IUniswapV2Router02 {\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '}\n', '\n', 'contract POLYDOGE is Context, IERC20, Ownable {\n', '    using SafeMath for uint256;\n', '    using Address for address;\n', '    mapping (address => uint256) private _rOwned;\n', '    mapping (address => uint256) private _tOwned;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    mapping (address => bool) private _isExcludedFromFee;\n', '    mapping (address => bool) private _isExcluded;\n', '    mapping (address => bool) private bots;\n', '    mapping (address => uint) private cooldown;\n', '    address[] private _excluded;\n', '    uint256 private constant MAX = ~uint256(0);\n', '    uint256 private constant _tTotal = 1000000000000 * 10**9;\n', '    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n', '    uint256 private _tFeeTotal;\n', '    string public constant _name = "Dogecoin Polytopia";\n', '    string public constant _symbol = "PolyDoge";\n', '    uint8 private constant _decimals = 9;\n', '    uint256 private _taxFee = 5;\n', '    uint256 private _teamFee = 10;\n', '    uint256 private _previousTaxFee = _taxFee;\n', '    uint256 private _previousteamFee = _teamFee;\n', '    address payable private _FeeAddress;\n', '    address payable private _marketingWalletAddress;\n', '    IUniswapV2Router02 private uniswapV2Router;\n', '    address private uniswapV2Pair;\n', '    bool private tradingOpen;\n', '    bool private inSwap = false;\n', '    bool private swapEnabled = false;\n', '    bool private cooldownEnabled = false;\n', '    uint256 private _maxTxAmount = _tTotal;\n', '    event MaxTxAmountUpdated(uint _maxTxAmount);\n', '    modifier lockTheSwap {\n', '        inSwap = true;\n', '        _;\n', '        inSwap = false;\n', '    }\n', '    constructor (address payable FeeAddress, address payable marketingWalletAddress) public {\n', '        _FeeAddress = FeeAddress;\n', '        _marketingWalletAddress = marketingWalletAddress;\n', '        _rOwned[_msgSender()] = _rTotal;\n', '        _isExcludedFromFee[owner()] = true;\n', '        _isExcludedFromFee[address(this)] = true;\n', '        _isExcludedFromFee[FeeAddress] = true;\n', '        _isExcludedFromFee[marketingWalletAddress] = true;\n', '        emit Transfer(address(0), _msgSender(), _tTotal);\n', '    }\n', '\n', '    function name() public pure returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public pure returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public pure returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public view override returns (uint256) {\n', '        return _tTotal;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        if (_isExcluded[account]) return _tOwned[account];\n', '        return tokenFromReflection(_rOwned[account]);\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function setCooldownEnabled(bool onoff) external onlyOwner() {\n', '        cooldownEnabled = onoff;\n', '    }\n', '\n', '    function tokenFromReflection(uint256 rAmount) private view returns(uint256) {\n', '        require(rAmount <= _rTotal, "Amount must be less than total reflections");\n', '        uint256 currentRate =  _getRate();\n', '        return rAmount.div(currentRate);\n', '    }\n', '\n', '    function removeAllFee() private {\n', '        if(_taxFee == 0 && _teamFee == 0) return;\n', '        _previousTaxFee = _taxFee;\n', '        _previousteamFee = _teamFee;\n', '        _taxFee = 0;\n', '        _teamFee = 0;\n', '    }\n', '    \n', '    function restoreAllFee() private {\n', '        _taxFee = _previousTaxFee;\n', '        _teamFee = _previousteamFee;\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) private {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _transfer(address from, address to, uint256 amount) private {\n', '        require(from != address(0), "ERC20: transfer from the zero address");\n', '        require(to != address(0), "ERC20: transfer to the zero address");\n', '        require(amount > 0, "Transfer amount must be greater than zero");\n', '        \n', '        if (from != owner() && to != owner()) {\n', '            if (cooldownEnabled) {\n', '                if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {\n', '                    require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");\n', '                }\n', '            }\n', '            if(from != address(this)){\n', '                require(amount <= _maxTxAmount);\n', '                require(!bots[from] && !bots[to]);\n', '            }\n', '            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {\n', '                require(cooldown[to] < block.timestamp);\n', '                cooldown[to] = block.timestamp + (30 seconds);\n', '            }\n', '            uint256 contractTokenBalance = balanceOf(address(this));\n', '            if (!inSwap && from != uniswapV2Pair && swapEnabled) {\n', '                swapTokensForEth(contractTokenBalance);\n', '                uint256 contractETHBalance = address(this).balance;\n', '                if(contractETHBalance > 0) {\n', '                    sendETHToFee(address(this).balance);\n', '                }\n', '            }\n', '        }\n', '        bool takeFee = true;\n', '\n', '        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){\n', '            takeFee = false;\n', '        }\n', '\t\t\n', '        _tokenTransfer(from,to,amount,takeFee);\n', '    }\n', '\n', '    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(this);\n', '        path[1] = uniswapV2Router.WETH();\n', '        _approve(address(this), address(uniswapV2Router), tokenAmount);\n', '        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '            tokenAmount,\n', '            0,\n', '            path,\n', '            address(this),\n', '            block.timestamp\n', '        );\n', '    }\n', '        \n', '    function sendETHToFee(uint256 amount) private {\n', '        _FeeAddress.transfer(amount.div(2));\n', '        _marketingWalletAddress.transfer(amount.div(2));\n', '    }\n', '    \n', '    function manualswap() external {\n', '        require(_msgSender() == _FeeAddress);\n', '        uint256 contractBalance = balanceOf(address(this));\n', '        swapTokensForEth(contractBalance);\n', '    }\n', '    \n', '    function manualsend() external {\n', '        require(_msgSender() == _FeeAddress);\n', '        uint256 contractETHBalance = address(this).balance;\n', '        sendETHToFee(contractETHBalance);\n', '    }\n', '        \n', '    function openTrading() external onlyOwner() {\n', '        require(!tradingOpen,"trading is already open");\n', '        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '        uniswapV2Router = _uniswapV2Router;\n', '        _approve(address(this), address(uniswapV2Router), _tTotal);\n', '        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\n', '        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);\n', '        swapEnabled = true;\n', '        cooldownEnabled = false;\n', '        _maxTxAmount = 1 * 10**12 * 10**9;\n', '        tradingOpen = true;\n', '        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);\n', '    }\n', '    \n', '    function setBots(address[] memory bots_) public onlyOwner {\n', '        for (uint i = 0; i < bots_.length; i++) {\n', '            bots[bots_[i]] = true;\n', '        }\n', '    }\n', '    \n', '    function delBot(address notbot) public onlyOwner {\n', '        bots[notbot] = false;\n', '    }\n', '        \n', '    function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {\n', '        if(!takeFee)\n', '            removeAllFee();\n', '        if (_isExcluded[sender] && !_isExcluded[recipient]) {\n', '            _transferFromExcluded(sender, recipient, amount);\n', '        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {\n', '            _transferToExcluded(sender, recipient, amount);\n', '        } else if (_isExcluded[sender] && _isExcluded[recipient]) {\n', '            _transferBothExcluded(sender, recipient, amount);\n', '        } else {\n', '            _transferStandard(sender, recipient, amount);\n', '        }\n', '        if(!takeFee)\n', '            restoreAllFee();\n', '    }\n', '\n', '    function _transferStandard(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); \n', '        _takeTeam(tTeam); \n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    \n', '        _takeTeam(tTeam);           \n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);\n', '        _tOwned[sender] = _tOwned[sender].sub(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); \n', '        _takeTeam(tTeam);   \n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);\n', '        _tOwned[sender] = _tOwned[sender].sub(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   \n', '        _takeTeam(tTeam);         \n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _takeTeam(uint256 tTeam) private {\n', '        uint256 currentRate =  _getRate();\n', '        uint256 rTeam = tTeam.mul(currentRate);\n', '        _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);\n', '        if(_isExcluded[address(this)])\n', '            _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);\n', '    }\n', '\n', '    function _reflectFee(uint256 rFee, uint256 tFee) private {\n', '        _rTotal = _rTotal.sub(rFee);\n', '        _tFeeTotal = _tFeeTotal.add(tFee);\n', '    }\n', '\n', '    receive() external payable {}\n', '\n', '    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {\n', '        (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);\n', '        uint256 currentRate =  _getRate();\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);\n', '        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);\n', '    }\n', '\n', '    function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {\n', '        uint256 tFee = tAmount.mul(taxFee).div(100);\n', '        uint256 tTeam = tAmount.mul(TeamFee).div(100);\n', '        uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);\n', '        return (tTransferAmount, tFee, tTeam);\n', '    }\n', '\n', '    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {\n', '        uint256 rAmount = tAmount.mul(currentRate);\n', '        uint256 rFee = tFee.mul(currentRate);\n', '        uint256 rTeam = tTeam.mul(currentRate);\n', '        uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);\n', '        return (rAmount, rTransferAmount, rFee);\n', '    }\n', '\n', '    function _getRate() private view returns(uint256) {\n', '        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n', '        return rSupply.div(tSupply);\n', '    }\n', '\n', '    function _getCurrentSupply() private view returns(uint256, uint256) {\n', '        uint256 rSupply = _rTotal;\n', '        uint256 tSupply = _tTotal;      \n', '        for (uint256 i = 0; i < _excluded.length; i++) {\n', '            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);\n', '            rSupply = rSupply.sub(_rOwned[_excluded[i]]);\n', '            tSupply = tSupply.sub(_tOwned[_excluded[i]]);\n', '        }\n', '        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);\n', '        return (rSupply, tSupply);\n', '    }\n', '        \n', '    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {\n', '        require(maxTxPercent > 0, "Amount must be greater than 0");\n', '        _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);\n', '        emit MaxTxAmountUpdated(_maxTxAmount);\n', '    }\n', '}']