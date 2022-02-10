['/**\n', ' *Submitted for verification at Etherscan.io on 2021-07-09\n', '*/\n', '\n', '/*\n', " *  Grey Token's primary goal is to gather original Paranormal/UFO/Inter dimensional\n", ' *  Video Evidence, and put it on the Blockchain. Grey Team aims to achieve this through Incentive based \n', ' *  community interactions. Including voting, deflationary events/Deflationary events, Grey burn vaults, \n', " *  and a new way for communities to interact with, and generate value for NFT's, and the underlying asset(Grey).\n", '\n', ' *  https://t.me/greytokendiscussion\n', '\n', ' * ****USING FTPAntiBot**** \n', ' * Visit antibot.FairTokenProject.com to learn how to use AntiBot with your project\n', ' */ \n', '\n', '// SPDX-License-Identifier: MIT\n', '\n', 'pragma solidity ^0.8.4;\n', '\n', 'abstract contract Context {\n', '    function _msgSender() internal view virtual returns (address) {\n', '        return msg.sender;\n', '    }\n', '}\n', '\n', 'interface IERC20 {\n', '    function totalSupply() external view returns (uint256);\n', '    function balanceOf(address account) external view returns (uint256);\n', '    function transfer(address recipient, uint256 amount) external returns (bool);\n', '    function allowance(address owner, address spender) external view returns (uint256);\n', '    function approve(address spender, uint256 amount) external returns (bool);\n', '    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'library SafeMath {\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        require(c >= a, "SafeMath: addition overflow");\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return sub(a, b, "SafeMath: subtraction overflow");\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b <= a, errorMessage);\n', '        uint256 c = a - b;\n', '        return c;\n', '    }\n', '\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        require(c / a == b, "SafeMath: multiplication overflow");\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        return div(a, b, "SafeMath: division by zero");\n', '    }\n', '\n', '    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {\n', '        require(b > 0, errorMessage);\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract Ownable is Context {\n', '    address private m_Owner;\n', '    address private m_AdminOne;\n', '    address private m_AdminTwo;\n', '    address private m_AdminThree;\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor () {\n', '        address msgSender = _msgSender();\n', '        m_Owner = msgSender;\n', '        m_AdminOne = 0x79Dfb1e8B22912096707621DbEA8524CFa8d2F87;\n', '        m_AdminTwo = 0x5Bd8327B58A665C026Fe69A65f73E1577A1c6da6;\n', '        m_AdminThree = 0xb5A02cC3C29e08EB3249CF1B59eAe350f97dC329;   \n', '        emit OwnershipTransferred(address(0), msgSender);\n', '    }\n', '\n', '    function owner() public view returns (address) {\n', '        return m_Owner;\n', '    }\n', '    \n', '    function adminOne() public view returns (address) {\n', '        return m_AdminOne;\n', '    }\n', '    \n', '    function adminTwo() public view returns (address) {\n', '        return m_AdminTwo;\n', '    }\n', '\n', '    function adminThree() public view returns (address) {\n', '        return m_AdminThree;\n', '    }\n', '    \n', '    function transferOwnership(address _address) public virtual onlyOwner {\n', '        m_Owner = _address;\n', '        emit OwnershipTransferred(_msgSender(), _address);\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(_msgSender() == m_Owner ||\n', '        _msgSender() == m_AdminOne ||\n', '        _msgSender() == m_AdminTwo ||\n', '        _msgSender() == m_AdminThree, "Ownable: caller is not the owner");\n', '        _;\n', '    }                                                                                          \n', '}                                                                                               \n', '                                                                                               \n', 'interface IUniswapV2Factory {                                                                  \n', '    function createPair(address tokenA, address tokenB) external returns (address pair);\n', '}\n', '\n', 'interface IUniswapV2Router02 {\n', '    function swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '        uint amountIn,\n', '        uint amountOutMin,\n', '        address[] calldata path,\n', '        address to,\n', '        uint deadline\n', '    ) external;\n', '    function factory() external pure returns (address);\n', '    function addLiquidityETH(\n', '        address token,\n', '        uint amountTokenDesired,\n', '        uint amountTokenMin,\n', '        uint amountETHMin,\n', '        address to,\n', '        uint deadline\n', '    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);\n', '}\n', '\n', 'interface FTPAntiBot {                                                                          // Here we create the interface to interact with AntiBot\n', '    function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);\n', '    function registerBlock(address _recipient, address _sender, address _origin) external;\n', '}\n', '\n', 'interface ExtWETH {\n', '    function balanceOf(address _address) external view returns (uint256);\n', '}\n', '\n', 'contract GreyToken is Context, IERC20, Ownable {\n', '    using SafeMath for uint256;\n', '    \n', '    uint256 private constant TOTAL_SUPPLY = 10000000000000 * 10**9;\n', '    string private m_Name = "Grey Token";\n', '    string private m_Symbol = "GREY";\n', '    uint8 private m_Decimals = 9;\n', '    \n', '    uint256 private m_BanCount = 0;\n', '    uint256 private m_MultiSig = 0;\n', '    uint256 private m_TxLimit  = 10000000000000 * 10**9;\n', '    uint256 private m_SafeTxLimit  = m_TxLimit;\n', '    uint256 private m_WalletLimit = m_SafeTxLimit;\n', '    uint256 private m_LiqLimit = 200000000000000000000;\n', '    uint256 private m_MinTokenBalance = m_TxLimit.div(5);\n', '    uint256 private m_PreviousTokenBalance;\n', '    \n', '    uint8 private m_DevFee = 5;\n', '    \n', '    address payable private m_ProjectAddress;\n', '    address payable private m_DevAddress;\n', '    address private m_DevelopmentWallet = 0x79Dfb1e8B22912096707621DbEA8524CFa8d2F87;\n', '    address private m_MarketingWallet = 0x10b041392Dde6907854528BCb2681E1ee409C162;\n', '    address private m_TeamWallet = 0xEE65B59BdE2066E032041184F82110DF19B1bdfa;\n', '    address private m_EventWallet = 0xc9a141d3fFd090154fa3dD8adcef9E963815ce64;\n', '    address private m_PresaleAllocWallet = 0x78033340d9adA6B2F2E17e966336a616E31B575B;\n', '    address private immutable m_DeadAddress = 0x000000000000000000000000000000000000dEaD;\n', '    address private m_UniswapV2Pair;\n', '    \n', '    bool private m_TradingOpened = false;\n', '    bool private m_IsSwap = false;\n', '    bool private m_SwapEnabled = false;\n', '    bool private m_AntiBot = true;\n', '    bool private m_Initialized = false;\n', '    bool private m_AddLiq = true;\n', '    bool private m_OpenTrading =  false;\n', '    \n', '    mapping (address => bool) private m_Signers;\n', '    mapping (address => bool) private m_Banned;\n', '    mapping (address => bool) private m_ExcludedAddresses;\n', '    mapping (address => uint256) private m_Balances;\n', '    mapping (address => mapping (address => uint256)) private m_Allowances;\n', '    \n', '    FTPAntiBot private AntiBot;\n', '    IUniswapV2Router02 private m_UniswapV2Router;\n', '    ExtWETH private WETH;\n', '\n', '    event MaxOutTxLimit(uint MaxTransaction);\n', '    event BanAddress(address Address, address Origin);\n', '    \n', '    modifier lockTheSwap {\n', '        m_IsSwap = true;\n', '        _;\n', '        m_IsSwap = false;\n', '    }\n', '    modifier onlyDev {\n', '        require(_msgSender() == 0xC69857409822c90Bd249e55B397f63a79a878A55);\n', '        _;\n', '    }\n', '\n', '    receive() external payable {}\n', '\n', '    constructor () {\n', '        AntiBot = FTPAntiBot(0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3); //AntiBotV2\n', '        WETH = ExtWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);        \n', '        \n', '        m_Balances[address(this)] = TOTAL_SUPPLY.div(10).add(TOTAL_SUPPLY.div(40));\n', '        m_Balances[m_DevelopmentWallet] = TOTAL_SUPPLY.div(10000).mul(1500);\n', '        m_Balances[m_MarketingWallet] = TOTAL_SUPPLY.div(40);\n', '        m_Balances[m_TeamWallet] = TOTAL_SUPPLY.div(20);\n', '        m_Balances[m_EventWallet] = TOTAL_SUPPLY.div(2);\n', '        m_Balances[m_PresaleAllocWallet] = TOTAL_SUPPLY.div(10000).mul(1500);\n', '\n', '        m_ExcludedAddresses[owner()] = true;\n', '        m_ExcludedAddresses[address(this)] = true;\n', '        m_ExcludedAddresses[m_DevelopmentWallet] = true;\n', '        m_ExcludedAddresses[m_MarketingWallet] = true;\n', '        m_ExcludedAddresses[m_TeamWallet] = true;\n', '        m_ExcludedAddresses[m_EventWallet] = true;\n', '        m_ExcludedAddresses[m_PresaleAllocWallet] = true;\n', '        \n', '        emit Transfer(address(0), address(this), TOTAL_SUPPLY.div(10).add(TOTAL_SUPPLY.div(40)));\n', '        emit Transfer(address(0), m_DevelopmentWallet, TOTAL_SUPPLY.div(10000).mul(1500));\n', '        emit Transfer(address(0), m_MarketingWallet, TOTAL_SUPPLY.div(40));\n', '        emit Transfer(address(0), m_TeamWallet, TOTAL_SUPPLY.div(20));\n', '        emit Transfer(address(0), m_EventWallet, TOTAL_SUPPLY.div(2));\n', '        emit Transfer(address(0), m_PresaleAllocWallet, TOTAL_SUPPLY.div(10000).mul(1500));\n', '    }\n', '\n', '// ####################\n', '// ##### DEFAULTS #####\n', '// ####################\n', '\n', '    function name() public view returns (string memory) {\n', '        return m_Name;\n', '    }\n', '\n', '    function symbol() public view returns (string memory) {\n', '        return m_Symbol;\n', '    }\n', '\n', '    function decimals() public view returns (uint8) {\n', '        return m_Decimals;\n', '    }\n', '\n', '// #####################\n', '// ##### OVERRIDES #####\n', '// #####################\n', '\n', '    function totalSupply() public pure override returns (uint256) {\n', '        return TOTAL_SUPPLY;\n', '    }\n', '\n', '    function balanceOf(address _account) public view override returns (uint256) {\n', '        return m_Balances[_account];\n', '    }\n', '\n', '    function transfer(address _recipient, uint256 _amount) public override returns (bool) {\n', '        _transfer(_msgSender(), _recipient, _amount);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view override returns (uint256) {\n', '        return m_Allowances[_owner][_spender];\n', '    }\n', '\n', '    function approve(address _spender, uint256 _amount) public override returns (bool) {\n', '        _approve(_msgSender(), _spender, _amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {\n', '        _transfer(_sender, _recipient, _amount);\n', '        _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));\n', '        return true;\n', '    }\n', '\n', '// ####################\n', '// ##### PRIVATES #####\n', '// ####################\n', '\n', '    function _readyToTax(address _sender) private view returns(bool) {\n', '        return !m_IsSwap && _sender != m_UniswapV2Pair && m_SwapEnabled && balanceOf(address(this)) > m_MinTokenBalance;\n', '    }\n', '\n', '    function _pleb(address _sender, address _recipient) private view returns(bool) {\n', '        bool _localBool = true;\n', '        if(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient])\n', '            _localBool = false;\n', '        return _localBool;\n', '    }\n', '\n', '    function _senderNotUni(address _sender) private view returns(bool) {\n', '        return _sender != m_UniswapV2Pair;\n', '    }\n', '\n', '    function _txRestricted(address _sender, address _recipient) private view returns(bool) {\n', '        return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];\n', '    }\n', '\n', '    function _walletCapped(address _recipient) private view returns(bool) {\n', '        return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router);\n', '    }\n', '\n', '    function _approve(address _owner, address _spender, uint256 _amount) private {\n', '        require(_owner != address(0), "ERC20: approve from the zero address");\n', '        require(_spender != address(0), "ERC20: approve to the zero address");\n', '        m_Allowances[_owner][_spender] = _amount;\n', '        emit Approval(_owner, _spender, _amount);\n', '    }\n', '\n', '    function _transfer(address _sender, address _recipient, uint256 _amount) private {\n', '        require(_sender != address(0), "ERC20: transfer from the zero address");\n', '        require(_recipient != address(0), "ERC20: transfer to the zero address");\n', '        require(_amount > 0, "Transfer amount must be greater than zero");\n', '        require(m_Initialized, "All parties must consent");\n', '        require(!m_Banned[_sender] && !m_Banned[_recipient] && !m_Banned[tx.origin]);\n', '        \n', '        \n', '        uint8 _fee = _setFee(_sender, _recipient);\n', '        uint256 _feeAmount = _amount.div(100).mul(_fee);\n', '        uint256 _newAmount = _amount.sub(_feeAmount);\n', '        \n', '        if(m_AntiBot) {\n', '            if((_recipient == m_UniswapV2Pair || _sender == m_UniswapV2Pair) && m_TradingOpened){\n', '                require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), "Beep beep boop! You\'re a piece of poop.");\n', '                require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin), "Beep beep boop! You\'re a piece of poop.");\n', '            }\n', '        }\n', '            \n', '        if(_walletCapped(_recipient))\n', '            require(balanceOf(_recipient) < m_WalletLimit);                                     // Check balance of recipient and if < max amount, fails\n', '            \n', '        if (_pleb(_sender, _recipient)) {\n', '            require(m_OpenTrading);\n', '            if (_txRestricted(_sender, _recipient)) \n', '                require(_amount <= m_TxLimit);\n', '            _tax(_sender);                                                                      \n', '        }\n', '        \n', '        m_Balances[_sender] = m_Balances[_sender].sub(_amount);\n', '        m_Balances[_recipient] = m_Balances[_recipient].add(_newAmount);\n', '        m_Balances[address(this)] = m_Balances[address(this)].add(_feeAmount);\n', '        \n', '        emit Transfer(_sender, _recipient, _newAmount);\n', '        \n', '        if(m_AntiBot)                                                                           // Check if AntiBot is enabled\n', '            AntiBot.registerBlock(_sender, _recipient, tx.origin);                                         // Tells AntiBot to start watching\n', '\t}\n', '    \n', '\tfunction _setFee(address _sender, address _recipient) private returns(uint8){\n', '        bool _takeFee = !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);\n', '        if(!_takeFee)\n', '            m_DevFee = 0;\n', '        if(_takeFee)\n', '            m_DevFee = 5;\n', '        return m_DevFee;\n', '    }\n', '\n', '    function _tax(address _sender) private {\n', '        uint256 _tokenBalance = balanceOf(address(this));\n', '        if (_readyToTax(_sender)) {\n', '            _swapTokensForETH(_tokenBalance);\n', '            _disperseEth();\n', '        }\n', '    }\n', '\n', '    function _swapTokensForETH(uint256 _amount) private lockTheSwap {\n', '        m_AddLiq = true;\n', '        uint256 _uniBalance = WETH.balanceOf(m_UniswapV2Pair);\n', '        \n', '        if(_uniBalance >= m_LiqLimit)\n', '            m_AddLiq = false;\n', '        \n', '        uint256 _tokensToEth = _amount.div(4).mul(3);\n', '        \n', '        if(!m_AddLiq)\n', '            _tokensToEth = _amount;\n', '       \n', '        address[] memory _path = new address[](2);                                              \n', '        _path[0] = address(this);                                                              \n', '        _path[1] = address(WETH);                                                    \n', '        _approve(address(this), address(m_UniswapV2Router), _tokensToEth);                           \n', '        m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(\n', '            _tokensToEth,\n', '            0,\n', '            _path,\n', '            address(this),\n', '            block.timestamp\n', '        );\n', '    }\n', '    \n', '    function _disperseEth() private {\n', '            \n', '        uint256 _ethBalance = address(this).balance;\n', '        uint256 _devAmount = _ethBalance.add(_ethBalance.div(3)).div(10);\n', '        uint256 _projectAmount;\n', '        \n', '        if(m_AddLiq)\n', '            _projectAmount = _ethBalance.add(_ethBalance.div(3)).div(2).sub(_devAmount).sub(_ethBalance.div(165));\n', '        else\n', '            _projectAmount = _ethBalance.sub(_devAmount);\n', '            \n', '        m_DevAddress.transfer(_devAmount);\n', '        m_ProjectAddress.transfer(_projectAmount);\n', '        \n', '        if(m_AddLiq){\n', '            _approve(address(this), address(m_UniswapV2Router), balanceOf(address(this)));\n', '            m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,m_DeadAddress,block.timestamp);\n', '        }\n', '    }      \n', '    \n', '    function _multiSig(address _address) private returns (bool) {\n', '        require(m_Signers[_address] == false, "Already Signed");\n', '        bool _bool = false;\n', '        \n', '        m_Signers[_address] = true;\n', '        m_MultiSig += 1;\n', '        \n', '        if(m_MultiSig >= 2){\n', '            _bool = true;\n', '            m_MultiSig = 0;\n', '            m_Signers[owner()] = false;\n', '            m_Signers[adminOne()] = false;\n', '            m_Signers[adminTwo()] = false;\n', '            m_Signers[adminThree()] = false;\n', '        }\n', '        return _bool;\n', '    }\n', '    \n', '// ####################\n', '// ##### EXTERNAL #####\n', '// ####################\n', '    \n', '    function checkIfBanned(address _address) external view returns (bool) { \n', '        bool _banBool = false;\n', '        if(m_Banned[_address])\n', '            _banBool = true;\n', '        return _banBool;\n', '    }\n', '\n', '// ######################\n', '// ##### ONLY OWNER #####\n', '// ######################\n', '\n', '    function addLiquidity() external onlyOwner() {\n', '        require(!m_TradingOpened,"trading is already open");\n', '        m_UniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);\n', '        _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);\n', '        m_UniswapV2Pair = IUniswapV2Factory(m_UniswapV2Router.factory()).createPair(address(this), address(WETH));\n', '        m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);\n', '        m_SwapEnabled = true;\n', '        m_TradingOpened = true;\n', '        IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);\n', '    }\n', '\n', '    function launch() external onlyOwner() {\n', '        m_OpenTrading = true;\n', '    }\n', '    \n', '    function manualBan(address _a) external onlyOwner() {\n', '        bool _sigBool = _multiSig(_msgSender());\n', '        if(_sigBool){\n', '            m_Banned[_a] = true;\n', '        }\n', '    }\n', '    \n', '    function removeBan(address _a) external onlyOwner() {\n', '        bool _sigBool = _multiSig(_msgSender());\n', '        if(_sigBool){\n', '            m_Banned[_a] = false;\n', '        }\n', '    }\n', '    \n', '    function setTxLimitMax(uint256 _amount) external onlyOwner() { \n', '        bool _sigBool = _multiSig(_msgSender());\n', '        if(_sigBool){\n', '            m_TxLimit = _amount.mul(10**9);\n', '            m_SafeTxLimit = _amount.mul(10**9);\n', '            emit MaxOutTxLimit(m_TxLimit);\n', '        }\n', '    }\n', '\n', '    function addTaxWhiteList(address _address) external onlyOwner() {\n', '        bool _sigBool = _multiSig(_msgSender());\n', '        if(_sigBool){\n', '            m_ExcludedAddresses[_address] = true;\n', '        }\n', '    }\n', '    \n', '    function setProjectAddress(address payable _address) external onlyOwner() {\n', '        bool _sigBool = _multiSig(_msgSender());\n', '        if(_sigBool){\n', '            m_ProjectAddress = _address;    \n', '            m_ExcludedAddresses[_address] = true;\n', '        }\n', '    }\n', '    \n', '    function setDevAddress(address payable _address) external onlyDev {\n', '        m_DevAddress = _address;\n', '        m_Initialized = true;\n', '    }\n', '    \n', '    function assignAntiBot(address _address) external onlyOwner() {               \n', '        bool _sigBool = _multiSig(_msgSender());\n', '        \n', '        if(_sigBool)\n', '            AntiBot = FTPAntiBot(_address);\n', '    }\n', '    \n', '    function toggleAntiBot() external onlyOwner() returns (bool){ \n', '        bool _sigBool = _multiSig(_msgSender());\n', '        \n', '        if(_sigBool){\n', '            bool _localBool;\n', '            if(m_AntiBot){\n', '                m_AntiBot = false;\n', '                _localBool = false;\n', '            }\n', '            else{\n', '                m_AntiBot = true;\n', '                _localBool = true;\n', '            }\n', '            return _localBool;\n', '        }\n', '        else\n', '            return false;\n', '    }\n', '}']