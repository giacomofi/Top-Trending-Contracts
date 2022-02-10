['// SPDX-License-Identifier: MIT\n', 'pragma solidity ^0.6.12;\n', 'pragma experimental ABIEncoderV2;\n', '\n', 'import "./Context.sol";\n', 'import "./IERC20.sol";\n', 'import "./SafeMath.sol";\n', 'import "./ECDSA.sol";\n', '\n', 'contract ROTHS is Context, IERC20 {\n', '    using SafeMath for uint256; \n', '    using ECDSA for bytes32;\n', '\n', '    mapping (address => uint256) private _balances;\n', '    mapping (address => bool) private _whitelist;\n', '    mapping (address => mapping (address => uint256)) private _allowances;\n', '    mapping (address => uint256) private _noncesOut;\n', '    mapping (bytes32 => uint256) private _chainSwapOut;\n', '    mapping (address => uint256) private _noncesIn;\n', '    mapping (bytes32 => uint256) private _chainSwapIn;\n', '\n', '    uint256 private _totalSupply;\n', '    uint256 public _supplyOnEth;\n', '    address _swapAdmin;\n', '\n', "    string private _name='ROTHS';\n", "    string private _symbol='ROTHS';\n", '    uint8 private _decimals=18;\n', '    uint256 private _burnRate=100;\n', '    address public _admin;\n', '    bool private _mintedCommunityTokens=false;\n', '    bool private _mintedSaleTokens=false;\n', '    bool private _mintedFarmTokens=false;\n', '    address private _farmAddress;\n', '    \n', '    constructor () public {\n', '        _whitelist[_msgSender()]=true;\n', '        _admin=msg.sender;\n', '        _swapAdmin=msg.sender;\n', '        \n', '    }\n', '\n', '    \n', '    function name() public view returns (string memory) {\n', '        return _name;\n', '    }\n', '\n', '   \n', '    function symbol() public view returns (string memory) {\n', '        return _symbol;\n', '    }\n', '\n', '   \n', '    function decimals() public view returns (uint256) {\n', '        return _decimals;\n', '    }\n', '    \n', '    function burnRate() public view returns (uint256) {\n', '        return _burnRate;\n', '    }\n', '\n', '   \n', '    function totalSupply() public view override returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '\n', '   \n', '    function balanceOf(address account) public view override returns (uint256) {\n', '        return _balances[account];\n', '    }\n', '    \n', '    function getNonceOut(address account) public view returns (uint256) {\n', '        return _noncesOut[account]+1;\n', '    }\n', '    function getNonceIn(address account) public view returns (uint256) {\n', '        return _noncesIn[account]+1;\n', '    }\n', '    function getChainSwapOut(bytes32 hash) public view returns (uint256) {\n', '        return _chainSwapOut[hash];\n', '    }\n', '    function getChainSwapIn(bytes32 hash) public view returns (uint256) {\n', '        return _chainSwapIn[hash];\n', '    }\n', '    \n', '    \n', '    function updateAdmin(address newAdmin) public virtual {\n', '        require(_msgSender() == _admin, "You do not have permissions to perfrom the following task.");\n', '        _admin=newAdmin;\n', '    }\n', '    \n', '    function updateSwapAdmin(address newAdmin) public virtual {\n', '        require(_msgSender() == _admin, "You do not have permissions to perfrom the following task.");\n', '        _swapAdmin=newAdmin;\n', '    }\n', '    \n', '    function mintCommunityTokens(address communityAddress) public virtual returns(bool){\n', '        require(_msgSender()==_admin,"ERC20: You don\'t have permissions to perfrom the selected task.");\n', '        require(_mintedCommunityTokens==false,"ERC20: Tokens for sale have already been minted.");\n', '        _mint(communityAddress,100e23);\n', '        _mintedCommunityTokens=true;\n', '        _whitelist[communityAddress]=true;\n', '        return true;\n', '    }\n', '\n', '    function mintSaleTokens(address saleAddress) public virtual returns(bool){\n', '        require(_msgSender()==_admin,"ERC20: You don\'t have permissions to perfrom the selected task.");\n', '        require(_mintedSaleTokens==false,"ERC20: Tokens for sale have already been minted.");\n', '        _mint(saleAddress,105e23);\n', '        _mintedSaleTokens=true;\n', '        _whitelist[saleAddress]=true;\n', '        return true;\n', '    }\n', '    \n', '    function mintFarmTokens(address farmAddress) public virtual returns(bool){\n', '        require(_msgSender()==_admin,"ERC20: You don\'t have permissions to perfrom the selected task.");\n', '        require(_mintedFarmTokens==false,"ERC20: Tokens for farm have already been minted.");\n', '        _farmAddress=farmAddress;\n', '        _mint(farmAddress,895e23);\n', '        _mintedFarmTokens=true;\n', '        _whitelist[farmAddress]=true;\n', '        return true;\n', '    }\n', '   \n', '   \n', '    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(_msgSender(), recipient, amount);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function allowance(address admin, address spender) public view virtual override returns (uint256) {\n', '        return _allowances[admin][spender];\n', '    }\n', '\n', '    \n', '    function approve(address spender, uint256 amount) public virtual override returns (bool) {\n', '        _approve(_msgSender(), spender, amount);\n', '        return true;\n', '    }\n', '\n', '   \n', '    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {\n', '        _transfer(sender, recipient, amount);\n', '        if (_msgSender() != _farmAddress){\n', '            _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));\n', '        }\n', '        return true;\n', '    }\n', '    \n', '    \n', '\n', '   \n', '    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));\n', '        return true;\n', '    }\n', '\n', '    \n', '    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {\n', '        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));\n', '        return true;\n', '    }\n', '\n', '    \n', '    function _transfer(address sender, address recipient, uint256 amount) internal virtual {\n', '        require(sender != address(0), "ERC20: transfer from the zero address");\n', '        require(recipient != address(0), "ERC20: transfer to the zero address");\n', '\n', '        _beforeTokenTransfer(sender, recipient, amount);\n', '\n', '        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");\n', '        _balances[recipient] = _balances[recipient].add(amount);\n', '        if (!(_whitelist[sender]||_whitelist[recipient])){\n', '            _burn(recipient,amount.mul(_burnRate).div(10e6));\n', '        }\n', '        emit Transfer(sender, recipient, amount);\n', '    }\n', '\n', '   \n', '    function _mint(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: mint to the zero address");\n', '\n', '        _beforeTokenTransfer(address(0), account, amount);\n', '\n', '        _totalSupply = _totalSupply.add(amount);\n', '        _supplyOnEth = _supplyOnEth.add(amount);\n', '        _balances[account] = _balances[account].add(amount);\n', '        emit Transfer(address(0), account, amount);\n', '    }\n', '\n', '    function _burn(address account, uint256 amount) internal virtual {\n', '        require(account != address(0), "ERC20: burn from the zero address");\n', '\n', '        _beforeTokenTransfer(account, address(0), amount);\n', '        _supplyOnEth = _supplyOnEth.sub(amount);\n', '        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");\n', '        _totalSupply = _totalSupply.sub(amount);\n', '        emit Transfer(account, address(0), amount);\n', '    }\n', '\n', '  \n', '    function _approve(address admin, address spender, uint256 amount) internal virtual {\n', '        require(admin != address(0), "ERC20: approve from the zero address");\n', '        require(spender != address(0), "ERC20: approve to the zero address");\n', '\n', '        _allowances[admin][spender] = amount;\n', '        emit Approval(admin, spender, amount);\n', '    }\n', '    \n', '    \n', '    function swapToBSC(uint256 amount) public virtual {\n', '        _burn(_msgSender(), amount);\n', '        _chainSwapOut[keccak256(abi.encodePacked(_msgSender(), getNonceOut(_msgSender())))] = amount;\n', '        _noncesOut[_msgSender()]++;\n', '    }\n', '    \n', '    function swapFromBSC(uint256 amount, bytes memory sig) public virtual {\n', '        _noncesIn[_msgSender()]++;\n', '        bytes32 digest = keccak256(abi.encodePacked(_msgSender(),amount,_noncesIn[_msgSender()]));\n', '        require(digest.recover(sig) == _swapAdmin, "Invalid signature");\n', '        _chainSwapIn[keccak256(abi.encodePacked(_msgSender(), getNonceIn(_msgSender())))] = amount;\n', '        _mint(_msgSender(), amount);\n', '    }\n', '\n', '\n', '    \n', '    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }\n', '}']