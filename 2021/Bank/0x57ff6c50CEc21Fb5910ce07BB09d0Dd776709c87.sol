['// WillyMusk $WMUSK\n', '// Telegram: https://t.me/WillyMusk\n', '// Website: https://willymusk.io/ | https://willymusk.com/\n', '\n', '// Bot protection\n', '// Friendly whale feature - the huge tax meant to rek sellers and reward holders\n', '// 25% burn on buy in order to reduce supply.\n', '// 5% burn on sale + 20% tax used for buybacks+marketing\n', '// In order to break even, you have to wait for 2x to not exit in a loss, wear your diamond gloves!\n', '// Change the last digit of token to 1 in uniswap in order to buy easily. slippage for sell 40% (for tax!)\n', '// Friendly whale wallets - 0x2F0a48810df43cFc4Ff7a833900AD7109f42583D / 0x3c199Dd0bdBbDa66FBE16026915bb28D6C470767\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', 'import "./libs/IERC20.sol";\n', 'import "./libs/SafeMath.sol";\n', 'import "./libs/Address.sol";\n', 'import "./libs/Ownable.sol";\n', 'import "./libs/IUniswapV2Pair.sol";\n', 'import "./libs/IUniswapV2Factory.sol";\n', 'import "./libs/IUniswapV2Router02.sol";\n', 'import "./libs/Context.sol";\n', '\n', 'contract WillyMuskToken is Context, IERC20, Ownable {\n', '    using SafeMath for uint256;\n', '\n', '    string private constant _name = "Willy Musk";\n', '    string private constant _symbol = "WMUSK";\n', '    uint8 private constant _decimals = 9;\n', '\n', '    // RFI\n', '    mapping(address => uint256) private _rOwned;\n', '    mapping(address => uint256) private _tOwned;\n', '    mapping(address => mapping(address => uint256)) private _allowances;\n', '    mapping(address => bool) private _isExcludedFromFee;\n', '    uint256 private constant MAX = ~uint256(0);\n', '    uint256 private constant _tTotal = 1000000000000 * 10**9;\n', '    uint256 private _rTotal = (MAX - (MAX % _tTotal));\n', '    uint256 private _tFeeTotal;\n', '    uint256 private _taxFee = 5;\n', '    uint256 private _teamFee = 20;\n', '\n', '    // Bot detection\n', '    mapping(address => bool) private bots;\n', '    mapping(address => uint256) private cooldown;\n', '    address payable private _teamAddress;\n', '    address payable private _marketingFunds;\n', '    IUniswapV2Router02 private uniswapV2Router;\n', '    address private uniswapV2Pair;\n', '    bool private tradingOpen;\n', '    bool private inSwap = false;\n', '    bool private swapEnabled = false;\n', '    bool private cooldownEnabled = false;\n', '    uint256 private _maxTxAmount = _tTotal;\n', '\n', '    event MaxTxAmountUpdated(uint256 _maxTxAmount);\n', '    modifier lockTheSwap {\n', '        inSwap = true;\n', '        _;\n', '        inSwap = false;\n', '    }\n', '\n', '    constructor(address payable addr1, address payable addr2) {\n', '        _teamAddress = addr1;\n', '        _marketingFunds = addr2;\n', '        _rOwned[_msgSender()] = _rTotal;\n', '        _isExcludedFromFee[owner()] = true;\n', '        _isExcludedFromFee[address(this)] = true;\n', '        _isExcludedFromFee[_teamAddress] = true;\n', '        _isExcludedFromFee[_marketingFunds] = true;\n', '        emit Transfer(address(0), _msgSender(), _tTotal);\n', '    }\n', '\n', '    function name() public pure returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '    function symbol() public pure returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '    function decimals() public pure returns (uint8) {\n', '        return _decimals;\n', '    }\n', '\n', '    function totalSupply() public pure override returns (uint256) {\n', '        return _tTotal;\n', '    }\n', '\n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return tokenFromReflection(_rOwned[account]);\n', '    }\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        public\n', '        override\n', '        returns (bool)\n', '    {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address owner, address spender)\n', '        public\n', '        view\n', '        override\n', '        returns (uint256)\n', '    {\n', '        return _allowances[owner][spender];\n', '    }\n', '\n', '    function approve(address spender, uint256 amount)\n', '        public\n', '        override\n', '        returns (bool)\n', '    {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) public override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        _approve(\n', '            sender,\n', '            _msgSender(),\n', '            _allowances[sender][_msgSender()].sub(\n', '                amount,\n', '                "ERC20: transfer amount exceeds allowance"\n', '            )\n', '        );\n', '        return true;\n', '    }\n', '\n', '    function setCooldownEnabled(bool onoff) external onlyOwner() {\n', '        cooldownEnabled = onoff;\n', '    }\n', '\n', '    function tokenFromReflection(uint256 rAmount)\n', '        private\n', '        view\n', '        returns (uint256)\n', '    {\n', '        require(\n', '            rAmount <= _rTotal,\n', '            "Amount must be less than total reflections"\n', '        );\n', '        uint256 currentRate = _getRate();\n', '        return rAmount.div(currentRate);\n', '    }\n', '\n', '    function removeAllFee() private {\n', '        if (_taxFee == 0 && _teamFee == 0) return;\n', '        _taxFee = 0;\n', '        _teamFee = 0;\n', '    }\n', '\n', '    function restoreAllFee() private {\n', '        _taxFee = 5;\n', '        _teamFee = 20;\n', '    }\n', '\n', '    function _approve(\n', '        address owner,\n', '        address spender,\n', '        uint256 amount\n', '    ) private {\n', '        require(owner != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '        _allowances[owner][spender] = amount;\n', '        emit Approval(owner, spender, amount);\n', '    }\n', '\n', '    function _transfer(\n', '        address from,\n', '        address to,\n', '        uint256 amount\n', '    ) private {\n', '        require(from != address(0), "ERC20: transfer from the zero address");\n', '        require(to != address(0), "ERC20: transfer to the zero address");\n', '        require(amount > 0, "Transfer amount must be greater than zero");\n', '\n', '        if (from != owner() && to != owner()) {\n', '            if (cooldownEnabled) {\n', '                if (\n', '                    from != address(this) &&\n', '                    to != address(this) &&\n', '                    from != address(uniswapV2Router) &&\n', '                    to != address(uniswapV2Router)\n', '                ) {\n', '                    require(\n', '                        _msgSender() == address(uniswapV2Router) ||\n', '                            _msgSender() == uniswapV2Pair,\n', '                        "ERR: Uniswap only"\n', '                    );\n', '                }\n', '            }\n', '            require(amount <= _maxTxAmount);\n', '            require(!bots[from] && !bots[to]);\n', '            if (\n', '                from == uniswapV2Pair &&\n', '                to != address(uniswapV2Router) &&\n', '                !_isExcludedFromFee[to] &&\n', '                cooldownEnabled\n', '            ) {\n', '                require(cooldown[to] < block.timestamp);\n', '                cooldown[to] = block.timestamp + (60 seconds);\n', '            }\n', '            uint256 contractTokenBalance = balanceOf(address(this));\n', '            if (!inSwap && from != uniswapV2Pair && swapEnabled) {\n', '                swapTokensForEth(contractTokenBalance);\n', '                uint256 contractETHBalance = address(this).balance;\n', '                if (contractETHBalance > 0) {\n', '                    sendETHToFee(address(this).balance);\n', '                }\n', '            }\n', '        }\n', '        bool takeFee = true;\n', '\n', '        if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {\n', '            takeFee = false;\n', '        }\n', '\n', '        _tokenTransfer(from, to, amount, takeFee);\n', '    }\n', '\n', '    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {\n', '        address[] memory path = new address[](2);\n', '        path[0] = address(this);\n', '        path[1] = uniswapV2Router.WETH();\n', '        _approve(address(this), address(uniswapV2Router), tokenAmount);\n', '        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '            tokenAmount,\n', '            0,\n', '            path,\n', '            address(this),\n', '            block.timestamp\n', '        );\n', '    }\n', '\n', '    function sendETHToFee(uint256 amount) private {\n', '        _teamAddress.transfer(amount.div(2));\n', '        _marketingFunds.transfer(amount.div(2));\n', '    }\n', '\n', '    function openTrading() external onlyOwner() {\n', '        require(!tradingOpen, "trading is already open");\n', '        IUniswapV2Router02 _uniswapV2Router =\n', '            IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '        uniswapV2Router = _uniswapV2Router;\n', '        _approve(address(this), address(uniswapV2Router), _tTotal);\n', '        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())\n', '            .createPair(address(this), _uniswapV2Router.WETH());\n', '        uniswapV2Router.addLiquidityETH{value: address(this).balance}(\n', '            address(this),\n', '            balanceOf(address(this)),\n', '            0,\n', '            0,\n', '            owner(),\n', '            block.timestamp\n', '        );\n', '        swapEnabled = true;\n', '        cooldownEnabled = true;\n', '        _maxTxAmount = 2500000000 * 10**9;\n', '        tradingOpen = true;\n', '        IERC20(uniswapV2Pair).approve(\n', '            address(uniswapV2Router),\n', '            type(uint256).max\n', '        );\n', '    }\n', '\n', '    function manualswap() external {\n', '        require(_msgSender() == _teamAddress);\n', '        uint256 contractBalance = balanceOf(address(this));\n', '        swapTokensForEth(contractBalance);\n', '    }\n', '\n', '    function manualsend() external {\n', '        require(_msgSender() == _teamAddress);\n', '        uint256 contractETHBalance = address(this).balance;\n', '        sendETHToFee(contractETHBalance);\n', '    }\n', '\n', '    function setBots(address[] memory bots_) public onlyOwner {\n', '        for (uint256 i = 0; i < bots_.length; i++) {\n', '            bots[bots_[i]] = true;\n', '        }\n', '    }\n', '\n', '    function delBot(address notbot) public onlyOwner {\n', '        bots[notbot] = false;\n', '    }\n', '\n', '    function _tokenTransfer(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount,\n', '        bool takeFee\n', '    ) private {\n', '        if (!takeFee) removeAllFee();\n', '        _transferStandard(sender, recipient, amount);\n', '        if (!takeFee) restoreAllFee();\n', '    }\n', '\n', '    function _transferStandard(\n', '        address sender,\n', '        address recipient,\n', '        uint256 tAmount\n', '    ) private {\n', '        (\n', '            uint256 rAmount,\n', '            uint256 rTransferAmount,\n', '            uint256 rFee,\n', '            uint256 tTransferAmount,\n', '            uint256 tFee,\n', '            uint256 tTeam\n', '        ) = _getValues(tAmount);\n', '        _rOwned[sender] = _rOwned[sender].sub(rAmount);\n', '        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);\n', '        _takeTeam(tTeam);\n', '        _reflectFee(rFee, tFee);\n', '        emit Transfer(sender, recipient, tTransferAmount);\n', '    }\n', '\n', '    function _takeTeam(uint256 tTeam) private {\n', '        uint256 currentRate = _getRate();\n', '        uint256 rTeam = tTeam.mul(currentRate);\n', '        _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);\n', '    }\n', '\n', '    function _reflectFee(uint256 rFee, uint256 tFee) private {\n', '        _rTotal = _rTotal.sub(rFee);\n', '        _tFeeTotal = _tFeeTotal.add(tFee);\n', '    }\n', '\n', '    receive() external payable {}\n', '\n', '    function _getValues(uint256 tAmount)\n', '        private\n', '        view\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256,\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        )\n', '    {\n', '        (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =\n', '            _getTValues(tAmount, _taxFee, _teamFee);\n', '        uint256 currentRate = _getRate();\n', '        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =\n', '            _getRValues(tAmount, tFee, tTeam, currentRate);\n', '        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);\n', '    }\n', '\n', '    function _getTValues(\n', '        uint256 tAmount,\n', '        uint256 taxFee,\n', '        uint256 TeamFee\n', '    )\n', '        private\n', '        pure\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        )\n', '    {\n', '        uint256 tFee = tAmount.mul(taxFee).div(100);\n', '        uint256 tTeam = tAmount.mul(TeamFee).div(100);\n', '        uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);\n', '        return (tTransferAmount, tFee, tTeam);\n', '    }\n', '\n', '    function _getRValues(\n', '        uint256 tAmount,\n', '        uint256 tFee,\n', '        uint256 tTeam,\n', '        uint256 currentRate\n', '    )\n', '        private\n', '        pure\n', '        returns (\n', '            uint256,\n', '            uint256,\n', '            uint256\n', '        )\n', '    {\n', '        uint256 rAmount = tAmount.mul(currentRate);\n', '        uint256 rFee = tFee.mul(currentRate);\n', '        uint256 rTeam = tTeam.mul(currentRate);\n', '        uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);\n', '        return (rAmount, rTransferAmount, rFee);\n', '    }\n', '\n', '    function _getRate() private view returns (uint256) {\n', '        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();\n', '        return rSupply.div(tSupply);\n', '    }\n', '\n', '    function _getCurrentSupply() private view returns (uint256, uint256) {\n', '        uint256 rSupply = _rTotal;\n', '        uint256 tSupply = _tTotal;\n', '        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);\n', '        return (rSupply, tSupply);\n', '    }\n', '\n', '    function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {\n', '        require(maxTxPercent > 0, "Amount must be greater than 0");\n', '        _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);\n', '        emit MaxTxAmountUpdated(_maxTxAmount);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '\n', '    function balanceOf(address account) external view returns (uint256);\n', '\n', '    function transfer(address recipient, uint256 amount)\n', '        external\n', '        returns (bool);\n', '\n', '    function allowance(address owner, address spender)\n', '        external\n', '        view\n', '        returns (uint256);\n', '\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '\n', '    function transferFrom(\n', '        address sender,\n', '        address recipient,\n', '        uint256 amount\n', '    ) external returns (bool);\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(\n', '        address indexed owner,\n', '        address indexed spender,\n', '        uint256 value\n', '    );\n', '}\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(\n', '        uint256 a,\n', '        uint256 b,\n', '        string memory errorMessage\n', '    ) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', 'library Address {\n', '\n', '    function isContract(address account) internal view returns (bool) {\n', '        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts\n', '        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned\n', "        // for accounts without code, i.e. `keccak256('')`\n", '        bytes32 codehash;\n', '        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;\n', '        // solhint-disable-next-line no-inline-assembly\n', '        assembly { codehash := extcodehash(account) }\n', '        return (codehash != accountHash && codehash != 0x0);\n', '    }\n', '\n', '    function sendValue(address payable recipient, uint256 amount) internal {\n', '        require(address(this).balance >= amount, "Address: insufficient balance");\n', '\n', '        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value\n', '        (bool success, ) = recipient.call{ value: amount }("");\n', '        require(success, "Address: unable to send value, recipient may have reverted");\n', '    }\n', '\n', '\n', '    function functionCall(address target, bytes memory data) internal returns (bytes memory) {\n', '        return functionCall(target, data, "Address: low-level call failed");\n', '    }\n', '\n', '    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {\n', '        return _functionCallWithValue(target, data, 0, errorMessage);\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {\n', '        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");\n', '    }\n', '\n', '    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {\n', '        require(address(this).balance >= value, "Address: insufficient balance for call");\n', '        return _functionCallWithValue(target, data, value, errorMessage);\n', '    }\n', '\n', '    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {\n', '        require(isContract(target), "Address: call to non-contract");\n', '\n', '        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);\n', '        if (success) {\n', '            return returndata;\n', '        } else {\n', '\n', '            if (returndata.length > 0) {\n', '                assembly {\n', '                    let returndata_size := mload(returndata)\n', '                    revert(add(32, returndata), returndata_size)\n', '                }\n', '            } else {\n', '                revert(errorMessage);\n', '            }\n', '        }\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', 'import "./Context.sol";\n', '\n', 'contract Ownable is Context {\n', '    address private _owner;\n', '    address private _previousOwner;\n', '    event OwnershipTransferred(\n', '        address indexed previousOwner,\n', '        address indexed newOwner\n', '    );\n', '\n', '    constructor() {\n', '        address msgSender = _msgSender();\n', '        _owner = msgSender;\n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return _owner;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_owner == _msgSender(), "Ownable: caller is not the owner");\n', '        _;\n', '    }\n', '\n', '    function renounceOwnership() public virtual onlyOwner {\n', '        emit OwnershipTransferred(_owner, address(0));\n', '        _owner = address(0);\n', '    }\n', '}\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity >=0.5.0;\n', '\n', 'interface IUniswapV2Pair {\n', '    event Approval(address indexed owner, address indexed spender, uint value);\n', '    event Transfer(address indexed from, address indexed to, uint value);\n', '\n', '    function name() external pure returns (string memory);\n', '    function symbol() external pure returns (string memory);\n', '    function decimals() external pure returns (uint8);\n', '    function totalSupply() external view returns (uint);\n', '    function balanceOf(address owner) external view returns (uint);\n', '    function allowance(address owner, address spender) external view returns (uint);\n', '\n', '    function approve(address spender, uint value) external returns (bool);\n', '    function transfer(address to, uint value) external returns (bool);\n', '    function transferFrom(address from, address to, uint value) external returns (bool);\n', '\n', '    function DOMAIN_SEPARATOR() external view returns (bytes32);\n', '    function PERMIT_TYPEHASH() external pure returns (bytes32);\n', '    function nonces(address owner) external view returns (uint);\n', '\n', '    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;\n', '\n', '    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);\n', '    event Swap(\n', '        address indexed sender,\n', '        uint amount0In,\n', '        uint amount1In,\n', '        uint amount0Out,\n', '        uint amount1Out,\n', '        address indexed to\n', '    );\n', '    event Sync(uint112 reserve0, uint112 reserve1);\n', '\n', '    function MINIMUM_LIQUIDITY() external pure returns (uint);\n', '    function factory() external view returns (address);\n', '    function token0() external view returns (address);\n', '    function token1() external view returns (address);\n', '    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);\n', '    function price0CumulativeLast() external view returns (uint);\n', '    function price1CumulativeLast() external view returns (uint);\n', '    function kLast() external view returns (uint);\n', '\n', '    function burn(address to) external returns (uint amount0, uint amount1);\n', '    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;\n', '    function skim(address to) external;\n', '    function sync() external;\n', '\n', '    function initialize(address, address) external;\n', '}\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity >=0.8.4;\n', '\n', 'interface IUniswapV2Factory {\n', '    function createPair(address tokenA, address tokenB)\n', '        external\n', '        returns (address pair);\n', '}\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity >=0.6.2;\n', '\n', 'interface IUniswapV2Router02 {\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint256 amountIn,\n', '        uint256 amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint256 deadline\n', '    ) external;\n', '\n', '    function factory() external pure returns (address);\n', '\n', '    function WETH() external pure returns (address);\n', '\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint256 amountTokenDesired,\n', '        uint256 amountTokenMin,\n', '        uint256 amountETHMin,\n', '        address to,\n', '        uint256 deadline\n', '    )\n', '        external\n', '        payable\n', '        returns (\n', '            uint256 amountToken,\n', '            uint256 amountETH,\n', '            uint256 liquidity\n', '        );\n', '}\n', '\n', '// SPDX-License-Identifier: Unlicensed\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', '{\n', '  "optimizer": {\n', '    "enabled": false,\n', '    "runs": 200\n', '  },\n', '  "outputSelection": {\n', '    "*": {\n', '      "*": [\n', '        "evm.bytecode",\n', '        "evm.deployedBytecode",\n', '        "abi"\n', '      ]\n', '    }\n', '  },\n', '  "libraries": {}\n', '}']