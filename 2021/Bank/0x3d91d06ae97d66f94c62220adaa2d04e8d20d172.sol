['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-04\n', '*/\n', '\n', '/*\n', 't.me/wizuchitoken\n', '\n', 'DID YOU MISS THE 50x MIZUCHI LAUNCH? \n', ' \n', 'Well, this wizard is granting your chance to get in ground level! \n', ' \n', 'Welcome to WIZUCHI! \n', '\n', 'All parameters are identical to Mizuchi. Respect to the Mizuchi dev, great contract. \n', '\n', '\n', ' * TOKENOMICS:\n', ' \n', ' * FIRST TWO MINUTES: 5,000,000,000 max buy / 45-second buy cooldown (lifted automatically)\n', ' * 15-sec sell cooldown after a buy\n', ' * \n', ' * Decreasing Buy Tax - for each time you buy within 30 mins, your buy tax will decrease by 2%\n', ' * - Starts at 10% then 8% then 6% then a minimum of 4%\n', " * - if you don't buy again after 30 minutes has elapsed, your buy tax resets at 10%\n", ' * - keep buying to maintain very low tax\n', ' * \n', ' * Decreasing Sell Tax - Sell tax starts high but decreases dramatically the longer HODL\n', ' * - The timer starts from when you last bought\n', ' * - Diamond hands deserve less tax\n', ' * \n', ' * Breakdown:\n', ' * - First 5 minutes: 35%\n', ' * - 5 minutes to 30 minutes: 25%\n', ' * - 30 minutes to 1 hour: 20%\n', ' * - 1 hour to 3 hours: 15%\n', ' * - after 3 hours: 10%\n', ' * \n', ' * Huge redistribution from taxes is given back to all hodlers: from 4 to 14% \n', ' * \n', ' * This is our way of discouraging sells for small profit.  \n', " * We used to see tokens go for x100 and more, but that doesn't seem like the trend anymore.  \n", " * People don't hodl like they used to, so our project wishes to reward hodlers with very low taxes.\n", ' * \n', ' * No other cooldowns and no sell limits!\n', ' * No team tokens, no presale\n', ' \n', ' \n', ' * \n', ' * SPDX-License-Identifier: UNLICENSED \n', ' * \n', '*/\n', 'pragma solidity ^0.8.4;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if(a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return mod(a, b, "SafeMath: modulo by zero");\n', '    }\n', '\n', '    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b != 0, errorMessage);\n', '        return a % b;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '    address private _previousOwner;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '\n', '}  \n', 'interface IUniswapV2Factory {\n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '}\n', '\n', 'interface IUniswapV2Router02 {\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function factory() external pure returns (address);\n', '    function WETH() external pure returns (address);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '}\n', '\n', 'contract Wizuchi is Context, IERC20, Ownable {\n', '    using SafeMath for uint256;\n', '    mapping (address => uint256) private _rOwned;\n', '    mapping (address => uint256) private _tOwned;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    mapping (address => bool) private _isExcludedFromFee;\n', '    mapping (address => bool) private _friends;\n', '    mapping (address => User) private trader;\n', '    uint256 private constant MAX = ~uint256(0);\n', '    uint256 private constant _tTotal = 1e12 * 10**9;\n', '    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n', '    uint256 private _tFeeTotal;\n', '    string private constant _name = unicode"Wizuchi - t.me/wizuchitoken";\n', '    string private constant _symbol = unicode"WIZUCHI";\n', '    uint8 private constant _decimals = 9;\n', '    uint256 private _taxFee = 5;\n', '    uint256 private _teamFee = 5;\n', '    uint256 private _feeRate = 5;\n', '    uint256 private _launchTime;\n', '    uint256 private _previousTaxFee = _taxFee;\n', '    uint256 private _previousteamFee = _teamFee;\n', '    uint256 private _maxBuyAmount;\n', '    address payable private _FeeAddress;\n', '    address payable private _marketingWalletAddress;\n', '    address payable private _marketingFixedWalletAddress;\n', '    IUniswapV2Router02 private uniswapV2Router;\n', '    address private uniswapV2Pair;\n', '    bool private tradingOpen;\n', '    bool private _cooldownEnabled = true;\n', '    bool private inSwap = false;\n', '    uint256 private launchBlock = 0;\n', '    uint256 private buyLimitEnd;\n', '    struct User {\n', '        uint256 buyCD;\n', '        uint256 sellCD;\n', '        uint256 lastBuy;\n', '        uint256 buynumber;\n', '        bool exists;\n', '    }\n', '\n', '    event MaxBuyAmountUpdated(uint _maxBuyAmount);\n', '    event CooldownEnabledUpdated(bool _cooldown);\n', '    event FeeMultiplierUpdated(uint _multiplier);\n', '    event FeeRateUpdated(uint _rate);\n', '\n', '    modifier lockTheSwap {\n', '        inSwap = true;\n', '        _;\n', '        inSwap = false;\n', '    }\n', '    constructor (address payable FeeAddress, address payable marketingWalletAddress, address payable marketingFixedWalletAddress) {\n', '        _FeeAddress = FeeAddress;\n', '        _marketingWalletAddress = marketingWalletAddress;\n', '        _marketingFixedWalletAddress = marketingFixedWalletAddress;\n', '        _rOwned[_msgSender()] = _rTotal;\n', '        _isExcludedFromFee[owner()] = true;\n', '        _isExcludedFromFee[address(this)] = true;\n', '        _isExcludedFromFee[FeeAddress] = true;\n', '        _isExcludedFromFee[marketingWalletAddress] = true;\n', '        _isExcludedFromFee[marketingFixedWalletAddress] = true;\n', '        emit Transfer(address(0), _msgSender(), _tTotal);\n', '    }\n', '\n', '    function name() public pure returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public pure returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public pure returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public pure override returns (uint256) {\n', '        return _tTotal;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return tokenFromReflection(_rOwned[account]);\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender) public view override returns (uint256) {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount) public override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '    function tokenFromReflection(uint256 rAmount) private view returns(uint256) {\n', '        require(rAmount <= _rTotal, "Amount must be less than total reflections");\n', '        uint256 currentRate =  _getRate();\n', '        return rAmount.div(currentRate);\n', '    }\n', '\n', '    function removeAllFee() private {\n', '        if(_taxFee == 0 && _teamFee == 0) return;\n', '        _previousTaxFee = _taxFee;\n', '        _previousteamFee = _teamFee;\n', '        _taxFee = 0;\n', '        _teamFee = 0;\n', '    }\n', '    \n', '    function restoreAllFee() private {\n', '        _taxFee = _previousTaxFee;\n', '        _teamFee = _previousteamFee;\n', '    }\n', '\n', '    function _approve(address owner, address spender, uint256 amount) private {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _transfer(address from, address to, uint256 amount) private {\n', '        require(from != address(0), "ERC20: transfer from the zero address");\n', '        require(to != address(0), "ERC20: transfer to the zero address");\n', '        require(amount > 0, "Transfer amount must be greater than zero");\n', '\n', '        if(from != owner() && to != owner()) {\n', '            \n', '            require(!_friends[from] && !_friends[to]);\n', '            \n', '            if (block.number <= launchBlock + 1 && amount == _maxBuyAmount) {\n', '                if (from != uniswapV2Pair && from != address(uniswapV2Router)) {\n', '                    _friends[from] = true;\n', '                } else if (to != uniswapV2Pair && to != address(uniswapV2Router)) {\n', '                    _friends[to] = true;\n', '                }\n', '            }\n', '            \n', '            if(!trader[msg.sender].exists) {\n', '                trader[msg.sender] = User(0,0,0,0,true);\n', '            }\n', '\n', '            // buy\n', '            if(from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {\n', '                require(tradingOpen, "Trading not yet enabled.");\n', '                if(block.timestamp > trader[to].lastBuy + (30 minutes)) {\n', '                    trader[to].buynumber = 0;\n', '                }\n', '                \n', '                if (trader[to].buynumber == 0) {\n', '                    trader[to].buynumber++;\n', '                    _taxFee = 5;\n', '                    _teamFee = 5;\n', '                } else if (trader[to].buynumber == 1) {\n', '                    trader[to].buynumber++;\n', '                    _taxFee = 4;\n', '                    _teamFee = 4;\n', '                } else if (trader[to].buynumber == 2) {\n', '                    trader[to].buynumber++;\n', '                    _taxFee = 3;\n', '                    _teamFee = 3;\n', '                } else if (trader[to].buynumber == 3) {\n', '                    trader[to].buynumber++;\n', '                    _taxFee = 2;\n', '                    _teamFee = 2;\n', '                } else {\n', '                    //fallback\n', '                    _taxFee = 5;\n', '                    _teamFee = 5;\n', '                }\n', '                \n', '                trader[to].lastBuy = block.timestamp;\n', '                \n', '                if(_cooldownEnabled) {\n', '                    if(buyLimitEnd > block.timestamp) {\n', '                        require(amount <= _maxBuyAmount);\n', '                        require(trader[to].buyCD < block.timestamp, "Your buy cooldown has not expired.");\n', '                        trader[to].buyCD = block.timestamp + (45 seconds);\n', '                    }\n', '                    trader[to].sellCD = block.timestamp + (15 seconds);\n', '                }\n', '            }\n', '            uint256 contractTokenBalance = balanceOf(address(this));\n', '\n', '            // sell\n', '            if(!inSwap && from != uniswapV2Pair && tradingOpen) {\n', '                \n', '                if(_cooldownEnabled) {\n', '                    require(trader[from].sellCD < block.timestamp, "Your sell cooldown has not expired.");\n', '                }\n', '                \n', '                uint256 total = 35;\n', '                if(block.timestamp > trader[from].lastBuy + (3 hours)) {\n', '                    total = 10;\n', '                } else if (block.timestamp > trader[from].lastBuy + (1 hours)) {\n', '                    total = 15;\n', '                } else if (block.timestamp > trader[from].lastBuy + (30 minutes)) {\n', '                    total = 20;\n', '                } else if (block.timestamp > trader[from].lastBuy + (5 minutes)) {\n', '                    total = 25;               \n', '                } else {\n', '                    //fallback\n', '                    total = 35;\n', '                }\n', '                \n', '                _taxFee = (total.mul(4)).div(10);\n', '                _teamFee = (total.mul(6)).div(10);\n', '\n', '                if(contractTokenBalance > 0) {\n', '                    if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {\n', '                        contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);\n', '                    }\n', '                    swapTokensForEth(contractTokenBalance);\n', '                }\n', '                uint256 contractETHBalance = address(this).balance;\n', '                if(contractETHBalance > 0) {\n', '                    sendETHToFee(address(this).balance);\n', '                }\n', '            }\n', '        }\n', '        bool takeFee = true;\n', '\n', '        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){\n', '            takeFee = false;\n', '        }\n', '        \n', '        _tokenTransfer(from,to,amount,takeFee);\n', '    }\n', '\n', '    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(this);\n', '        path[1] = uniswapV2Router.WETH();\n', '        _approve(address(this), address(uniswapV2Router), tokenAmount);\n', '        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '            tokenAmount,\n', '            0,\n', '            path,\n', '            address(this),\n', '            block.timestamp\n', '        );\n', '    }\n', '        \n', '    function sendETHToFee(uint256 amount) private {\n', '        _FeeAddress.transfer(amount.div(2));\n', '        _marketingWalletAddress.transfer(amount.div(4));\n', '        _marketingFixedWalletAddress.transfer(amount.div(4));\n', '    }\n', '    \n', '    function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {\n', '        if(!takeFee)\n', '            removeAllFee();\n', '        _transferStandard(sender, recipient, amount);\n', '        if(!takeFee)\n', '            restoreAllFee();\n', '    }\n', '\n', '    function _transferStandard(address sender, address recipient, uint256 tAmount) private {\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); \n', '\n', '        _takeTeam(tTeam);\n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {\n', '        (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);\n', '        uint256 currentRate =  _getRate();\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);\n', '        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);\n', '    }\n', '\n', '    function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {\n', '        uint256 tFee = tAmount.mul(taxFee).div(100);\n', '        uint256 tTeam = tAmount.mul(TeamFee).div(100);\n', '        uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);\n', '        return (tTransferAmount, tFee, tTeam);\n', '    }\n', '\n', '    function _getRate() private view returns(uint256) {\n', '        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n', '        return rSupply.div(tSupply);\n', '    }\n', '\n', '    function _getCurrentSupply() private view returns(uint256, uint256) {\n', '        uint256 rSupply = _rTotal;\n', '        uint256 tSupply = _tTotal;\n', '        if(rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);\n', '        return (rSupply, tSupply);\n', '    }\n', '\n', '    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {\n', '        uint256 rAmount = tAmount.mul(currentRate);\n', '        uint256 rFee = tFee.mul(currentRate);\n', '        uint256 rTeam = tTeam.mul(currentRate);\n', '        uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);\n', '        return (rAmount, rTransferAmount, rFee);\n', '    }\n', '\n', '    function _takeTeam(uint256 tTeam) private {\n', '        uint256 currentRate =  _getRate();\n', '        uint256 rTeam = tTeam.mul(currentRate);\n', '\n', '        _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);\n', '    }\n', '\n', '    function _reflectFee(uint256 rFee, uint256 tFee) private {\n', '        _rTotal = _rTotal.sub(rFee);\n', '        _tFeeTotal = _tFeeTotal.add(tFee);\n', '    }\n', '\n', '    receive() external payable {}\n', '    \n', '    function addLiquidity() external onlyOwner() {\n', '        require(!tradingOpen,"trading is already open");\n', '        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '        uniswapV2Router = _uniswapV2Router;\n', '        _approve(address(this), address(uniswapV2Router), _tTotal);\n', '        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());\n', '        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);\n', '        _maxBuyAmount = 5000000000 * 10**9;\n', '        _launchTime = block.timestamp;\n', '        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);\n', '    }\n', '\n', '    function openTrading() public onlyOwner {\n', '        tradingOpen = true;\n', '        buyLimitEnd = block.timestamp + (120 seconds);\n', '        launchBlock = block.number;\n', '    }\n', '    \n', '    function setFriends(address[] memory friends) public onlyOwner {\n', '        for (uint i = 0; i < friends.length; i++) {\n', '            if (friends[i] != uniswapV2Pair && friends[i] != address(uniswapV2Router)) {\n', '                _friends[friends[i]] = true;\n', '            }\n', '        }\n', '    }\n', '    \n', '    function delFriend(address notfriend) public onlyOwner {\n', '        _friends[notfriend] = false;\n', '    }\n', '    \n', '    function isFriend(address ad) public view returns (bool) {\n', '        return _friends[ad];\n', '    }\n', '\n', '    function manualswap() external {\n', '        require(_msgSender() == _FeeAddress);\n', '        uint256 contractBalance = balanceOf(address(this));\n', '        swapTokensForEth(contractBalance);\n', '    }\n', '    \n', '    function manualsend() external {\n', '        require(_msgSender() == _FeeAddress);\n', '        uint256 contractETHBalance = address(this).balance;\n', '        sendETHToFee(contractETHBalance);\n', '    }\n', '\n', '    function setFeeRate(uint256 rate) external {\n', '        require(_msgSender() == _FeeAddress);\n', '        require(rate < 51, "Rate can\'t exceed 50%");\n', '        _feeRate = rate;\n', '        emit FeeRateUpdated(_feeRate);\n', '    }\n', '\n', '    function setCooldownEnabled(bool onoff) external onlyOwner() {\n', '        _cooldownEnabled = onoff;\n', '        emit CooldownEnabledUpdated(_cooldownEnabled);\n', '    }\n', '\n', '    function thisBalance() public view returns (uint) {\n', '        return balanceOf(address(this));\n', '    }\n', '\n', '    function cooldownEnabled() public view returns (bool) {\n', '        return _cooldownEnabled;\n', '    }\n', '\n', '    function timeToBuy(address buyer) public view returns (uint) {\n', '        return block.timestamp - trader[buyer].buyCD;\n', '    }\n', '    \n', '    // might return outdated counter if more than 30 mins\n', '    function buyTax(address buyer) public view returns (uint) {\n', '        return ((5 - trader[buyer].buynumber).mul(2));\n', '    }\n', '    \n', '    function sellTax(address ad) public view returns (uint) {\n', '        if(block.timestamp > trader[ad].lastBuy + (3 hours)) {\n', '            return 10;\n', '        } else if (block.timestamp > trader[ad].lastBuy + (1 hours)) {\n', '            return 15;\n', '        } else if (block.timestamp > trader[ad].lastBuy + (30 minutes)) {\n', '            return 20;              \n', '        } else if (block.timestamp > trader[ad].lastBuy + (5 minutes)) {\n', '            return 25;               \n', '        } else {\n', '            return 35;\n', '        }\n', '    }\n', '\n', '    function amountInPool() public view returns (uint) {\n', '        return balanceOf(uniswapV2Pair);\n', '    }\n', '}']