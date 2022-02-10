['pragma solidity ^0.4.18;\n', '\n', 'contract DSAuthority {\n', '    function canCall(\n', '        address src, address dst, bytes4 sig\n', '    ) public view returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    function DSAuth() public {\n', '        owner = msg.sender;\n', '        LogSetOwner(msg.sender);\n', '    }\n', '\n', '    function setOwner(address owner_)\n', '    public\n', '    auth\n', '    {\n', '        owner = owner_;\n', '        LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '    public\n', '    auth\n', '    {\n', '        authority = authority_;\n', '        LogSetAuthority(authority);\n', '    }\n', '\n', '    modifier auth {\n', '        require(isAuthorized(msg.sender, msg.sig));\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, this, sig);\n', '        }\n', '    }\n', '}\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    /// @return total amount of tokens\n', '    function totalSupply() constant public returns (uint256 supply);\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract LemoSale is DSAuth, DSMath {\n', '    ERC20 public token;                  // The LemoCoin token\n', '\n', '    bool public funding = true; // funding state\n', '\n', '    uint256 public startTime = 0; // crowdsale start time (in seconds)\n', '    uint256 public endTime = 0; // crowdsale end time (in seconds)\n', '    uint256 public finney2LemoRate = 0; // how many tokens one wei equals\n', '    uint256 public tokenContributionCap = 0; // max amount raised during crowdsale\n', '    uint256 public tokenContributionMin = 0; // min amount raised during crowdsale\n', '    uint256 public soldAmount = 0; // total sold token amount\n', '    uint256 public minPayment = 0; // min eth each time\n', '    uint256 public contributionCount = 0;\n', '\n', '    // triggered when contribute successful\n', '    event Contribution(address indexed _contributor, uint256 _amount, uint256 _return);\n', '    // triggered when refund successful\n', '    event Refund(address indexed _from, uint256 _value);\n', '    // triggered when crowdsale is over\n', '    event Finalized(uint256 _time);\n', '\n', '    modifier between(uint256 _startTime, uint256 _endTime) {\n', '        require(block.timestamp >= _startTime && block.timestamp < _endTime);\n', '        _;\n', '    }\n', '\n', '    function LemoSale(uint256 _tokenContributionMin, uint256 _tokenContributionCap, uint256 _finney2LemoRate) public {\n', '        require(_finney2LemoRate > 0);\n', '        require(_tokenContributionMin > 0);\n', '        require(_tokenContributionCap > 0);\n', '        require(_tokenContributionCap > _tokenContributionMin);\n', '\n', '        finney2LemoRate = _finney2LemoRate;\n', '        tokenContributionMin = _tokenContributionMin;\n', '        tokenContributionCap = _tokenContributionCap;\n', '    }\n', '\n', '    function initialize(uint256 _startTime, uint256 _endTime, uint256 _minPaymentFinney) public auth {\n', '        require(_startTime < _endTime);\n', '        require(_minPaymentFinney > 0);\n', '\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        // Ether is to big to pass in the function, So we use Finney. 1 Finney = 0.001 Ether\n', '        minPayment = _minPaymentFinney * 1 finney;\n', '    }\n', '\n', '    function setTokenContract(ERC20 tokenInstance) public auth {\n', '        assert(address(token) == address(0));\n', '        require(tokenInstance.balanceOf(owner) > tokenContributionMin);\n', '\n', '        token = tokenInstance;\n', '    }\n', '\n', '    function() public payable {\n', '        contribute();\n', '    }\n', '\n', '    function contribute() public payable between(startTime, endTime) {\n', '        uint256 max = tokenContributionCap;\n', '        uint256 oldSoldAmount = soldAmount;\n', '        require(oldSoldAmount < max);\n', '        require(msg.value >= minPayment);\n', '\n', '        uint256 reward = mul(msg.value, finney2LemoRate) / 1 finney;\n', '        uint256 refundEth = 0;\n', '\n', '        uint256 newSoldAmount = add(oldSoldAmount, reward);\n', '        if (newSoldAmount > max) {\n', '            uint over = newSoldAmount - max;\n', '            refundEth = over / finney2LemoRate * 1 finney;\n', '            reward = max - oldSoldAmount;\n', '            soldAmount = max;\n', '        } else {\n', '            soldAmount = newSoldAmount;\n', '        }\n', '\n', '        token.transferFrom(owner, msg.sender, reward);\n', '        Contribution(msg.sender, msg.value, reward);\n', '        contributionCount++;\n', '        if (refundEth > 0) {\n', '            Refund(msg.sender, refundEth);\n', '            msg.sender.transfer(refundEth);\n', '        }\n', '    }\n', '\n', '    function finalize() public auth {\n', '        require(funding);\n', '        require(block.timestamp >= endTime);\n', '        require(soldAmount >= tokenContributionMin);\n', '\n', '        funding = false;\n', '        Finalized(block.timestamp);\n', '        owner.transfer(this.balance);\n', '    }\n', '\n', '    // Withdraw in 3 month after failed. So funds not locked in contract forever\n', '    function withdraw() public auth {\n', '        require(this.balance > 0);\n', '        require(block.timestamp >= endTime + 3600 * 24 * 30 * 3);\n', '\n', '        owner.transfer(this.balance);\n', '    }\n', '\n', '    function destroy() public auth {\n', '        require(block.timestamp >= endTime + 3600 * 24 * 30 * 3);\n', '\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function refund() public {\n', '        require(funding);\n', '        require(block.timestamp >= endTime && soldAmount <= tokenContributionMin);\n', '\n', '        uint256 tokenAmount = token.balanceOf(msg.sender);\n', '        require(tokenAmount > 0);\n', '\n', '        // need user approve first\n', '        token.transferFrom(msg.sender, owner, tokenAmount);\n', '        soldAmount = sub(soldAmount, tokenAmount);\n', '\n', '        uint256 refundEth = tokenAmount / finney2LemoRate * 1 finney;\n', '        Refund(msg.sender, refundEth);\n', '        msg.sender.transfer(refundEth);\n', '    }\n', '}']
['pragma solidity ^0.4.18;\n', '\n', 'contract DSAuthority {\n', '    function canCall(\n', '        address src, address dst, bytes4 sig\n', '    ) public view returns (bool);\n', '}\n', '\n', 'contract DSAuthEvents {\n', '    event LogSetAuthority (address indexed authority);\n', '    event LogSetOwner     (address indexed owner);\n', '}\n', '\n', 'contract DSAuth is DSAuthEvents {\n', '    DSAuthority  public  authority;\n', '    address      public  owner;\n', '\n', '    function DSAuth() public {\n', '        owner = msg.sender;\n', '        LogSetOwner(msg.sender);\n', '    }\n', '\n', '    function setOwner(address owner_)\n', '    public\n', '    auth\n', '    {\n', '        owner = owner_;\n', '        LogSetOwner(owner);\n', '    }\n', '\n', '    function setAuthority(DSAuthority authority_)\n', '    public\n', '    auth\n', '    {\n', '        authority = authority_;\n', '        LogSetAuthority(authority);\n', '    }\n', '\n', '    modifier auth {\n', '        require(isAuthorized(msg.sender, msg.sig));\n', '        _;\n', '    }\n', '\n', '    function isAuthorized(address src, bytes4 sig) internal view returns (bool) {\n', '        if (src == address(this)) {\n', '            return true;\n', '        } else if (src == owner) {\n', '            return true;\n', '        } else if (authority == DSAuthority(0)) {\n', '            return false;\n', '        } else {\n', '            return authority.canCall(src, this, sig);\n', '        }\n', '    }\n', '}\n', '\n', 'contract DSMath {\n', '    function add(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x + y) >= x);\n', '    }\n', '\n', '    function sub(uint x, uint y) internal pure returns (uint z) {\n', '        require((z = x - y) <= x);\n', '    }\n', '\n', '    function mul(uint x, uint y) internal pure returns (uint z) {\n', '        require(y == 0 || (z = x * y) / y == x);\n', '    }\n', '}\n', '\n', 'contract ERC20 {\n', '    /// @return total amount of tokens\n', '    function totalSupply() constant public returns (uint256 supply);\n', '\n', '    /// @param _owner The address from which the balance will be retrieved\n', '    /// @return The balance\n', '    function balanceOf(address _owner) constant public returns (uint256 balance);\n', '\n', '    /// @notice send `_value` token to `_to` from `msg.sender`\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transfer(address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`\n', '    /// @param _from The address of the sender\n', '    /// @param _to The address of the recipient\n', '    /// @param _value The amount of token to be transferred\n', '    /// @return Whether the transfer was successful or not\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);\n', '\n', '    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @param _value The amount of wei to be approved for transfer\n', '    /// @return Whether the approval was successful or not\n', '    function approve(address _spender, uint256 _value) public returns (bool success);\n', '\n', '    /// @param _owner The address of the account owning tokens\n', '    /// @param _spender The address of the account able to transfer the tokens\n', '    /// @return Amount of remaining tokens allowed to spent\n', '    function allowance(address _owner, address _spender) constant public returns (uint256 remaining);\n', '\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _owner, address indexed _spender, uint256 _value);\n', '}\n', '\n', 'contract LemoSale is DSAuth, DSMath {\n', '    ERC20 public token;                  // The LemoCoin token\n', '\n', '    bool public funding = true; // funding state\n', '\n', '    uint256 public startTime = 0; // crowdsale start time (in seconds)\n', '    uint256 public endTime = 0; // crowdsale end time (in seconds)\n', '    uint256 public finney2LemoRate = 0; // how many tokens one wei equals\n', '    uint256 public tokenContributionCap = 0; // max amount raised during crowdsale\n', '    uint256 public tokenContributionMin = 0; // min amount raised during crowdsale\n', '    uint256 public soldAmount = 0; // total sold token amount\n', '    uint256 public minPayment = 0; // min eth each time\n', '    uint256 public contributionCount = 0;\n', '\n', '    // triggered when contribute successful\n', '    event Contribution(address indexed _contributor, uint256 _amount, uint256 _return);\n', '    // triggered when refund successful\n', '    event Refund(address indexed _from, uint256 _value);\n', '    // triggered when crowdsale is over\n', '    event Finalized(uint256 _time);\n', '\n', '    modifier between(uint256 _startTime, uint256 _endTime) {\n', '        require(block.timestamp >= _startTime && block.timestamp < _endTime);\n', '        _;\n', '    }\n', '\n', '    function LemoSale(uint256 _tokenContributionMin, uint256 _tokenContributionCap, uint256 _finney2LemoRate) public {\n', '        require(_finney2LemoRate > 0);\n', '        require(_tokenContributionMin > 0);\n', '        require(_tokenContributionCap > 0);\n', '        require(_tokenContributionCap > _tokenContributionMin);\n', '\n', '        finney2LemoRate = _finney2LemoRate;\n', '        tokenContributionMin = _tokenContributionMin;\n', '        tokenContributionCap = _tokenContributionCap;\n', '    }\n', '\n', '    function initialize(uint256 _startTime, uint256 _endTime, uint256 _minPaymentFinney) public auth {\n', '        require(_startTime < _endTime);\n', '        require(_minPaymentFinney > 0);\n', '\n', '        startTime = _startTime;\n', '        endTime = _endTime;\n', '        // Ether is to big to pass in the function, So we use Finney. 1 Finney = 0.001 Ether\n', '        minPayment = _minPaymentFinney * 1 finney;\n', '    }\n', '\n', '    function setTokenContract(ERC20 tokenInstance) public auth {\n', '        assert(address(token) == address(0));\n', '        require(tokenInstance.balanceOf(owner) > tokenContributionMin);\n', '\n', '        token = tokenInstance;\n', '    }\n', '\n', '    function() public payable {\n', '        contribute();\n', '    }\n', '\n', '    function contribute() public payable between(startTime, endTime) {\n', '        uint256 max = tokenContributionCap;\n', '        uint256 oldSoldAmount = soldAmount;\n', '        require(oldSoldAmount < max);\n', '        require(msg.value >= minPayment);\n', '\n', '        uint256 reward = mul(msg.value, finney2LemoRate) / 1 finney;\n', '        uint256 refundEth = 0;\n', '\n', '        uint256 newSoldAmount = add(oldSoldAmount, reward);\n', '        if (newSoldAmount > max) {\n', '            uint over = newSoldAmount - max;\n', '            refundEth = over / finney2LemoRate * 1 finney;\n', '            reward = max - oldSoldAmount;\n', '            soldAmount = max;\n', '        } else {\n', '            soldAmount = newSoldAmount;\n', '        }\n', '\n', '        token.transferFrom(owner, msg.sender, reward);\n', '        Contribution(msg.sender, msg.value, reward);\n', '        contributionCount++;\n', '        if (refundEth > 0) {\n', '            Refund(msg.sender, refundEth);\n', '            msg.sender.transfer(refundEth);\n', '        }\n', '    }\n', '\n', '    function finalize() public auth {\n', '        require(funding);\n', '        require(block.timestamp >= endTime);\n', '        require(soldAmount >= tokenContributionMin);\n', '\n', '        funding = false;\n', '        Finalized(block.timestamp);\n', '        owner.transfer(this.balance);\n', '    }\n', '\n', '    // Withdraw in 3 month after failed. So funds not locked in contract forever\n', '    function withdraw() public auth {\n', '        require(this.balance > 0);\n', '        require(block.timestamp >= endTime + 3600 * 24 * 30 * 3);\n', '\n', '        owner.transfer(this.balance);\n', '    }\n', '\n', '    function destroy() public auth {\n', '        require(block.timestamp >= endTime + 3600 * 24 * 30 * 3);\n', '\n', '        selfdestruct(owner);\n', '    }\n', '\n', '    function refund() public {\n', '        require(funding);\n', '        require(block.timestamp >= endTime && soldAmount <= tokenContributionMin);\n', '\n', '        uint256 tokenAmount = token.balanceOf(msg.sender);\n', '        require(tokenAmount > 0);\n', '\n', '        // need user approve first\n', '        token.transferFrom(msg.sender, owner, tokenAmount);\n', '        soldAmount = sub(soldAmount, tokenAmount);\n', '\n', '        uint256 refundEth = tokenAmount / finney2LemoRate * 1 finney;\n', '        Refund(msg.sender, refundEth);\n', '        msg.sender.transfer(refundEth);\n', '    }\n', '}']
