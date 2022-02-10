['pragma solidity ^0.4.24;\n', '///////////////////////////////////////////////////\n', '//  \n', '//  `iCashweb` ICW Token Contract\n', '//\n', '//  Total Tokens: 300,000,000.000000000000000000\n', '//  Name: iCashweb\n', '//  Symbol: ICWeb\n', '//  Decimal Scheme: 18\n', '//  \n', '//  by Nishad Vadgama\n', '///////////////////////////////////////////////////\n', '\n', 'library iMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract iCashwebToken {\n', '    \n', '    address public iOwner;\n', '    mapping(address => bool) iOperable;\n', '    bool _mintingStarted;\n', '    bool _minted;\n', '\n', '    modifier notMinted() {\n', '        require(_minted == false);\n', '        _;\n', '    }\n', '\n', '    modifier mintingStarted() {\n', '        require(_mintingStarted == true);\n', '        _;\n', '    }\n', '    \n', '    modifier iOnlyOwner() {\n', '        require(msg.sender == iOwner || iOperable[msg.sender] == true);\n', '        _;\n', '    }\n', '    \n', '    function manageOperable(address _from, bool _value) public returns(bool) {\n', '        require(msg.sender == iOwner);\n', '        iOperable[_from] = _value;\n', '        emit Operable(msg.sender, _from, _value);\n', '        return true;\n', '    }\n', '\n', '    function isOperable(address _addr) public view returns(bool) {\n', '        return iOperable[_addr];\n', '    }\n', '\n', '    function manageMinting(bool _val) public {\n', '        require(msg.sender == iOwner);\n', '        _mintingStarted = _val;\n', '        emit Minting(_val);\n', '    }\n', '\n', '    function destroyContract() public {\n', '        require(msg.sender == iOwner);\n', '        selfdestruct(iOwner);\n', '    }\n', '    \n', '    event Operable(address _owner, address _from, bool _value);\n', '    event Minting(bool _value);\n', '    event OwnerTransferred(address _from, address _to);\n', '}\n', '\n', 'contract iCashweb is iCashwebToken {\n', '    using iMath for uint256;\n', '    \n', '    string public constant name = "iCashweb";\n', '    string public constant symbol = "ICWs";\n', '    uint8 public constant decimals = 18;\n', '    uint256 _totalSupply;\n', '    uint256 _rate;\n', '    uint256 _totalMintSupply;\n', '    uint256 _maxMintable;\n', '    mapping (address => uint256) _balances;\n', '    mapping (address => mapping (address => uint256)) _approvals;\n', '    \n', '    constructor (uint256 _price, uint256 _val) public {\n', '        iOwner = msg.sender;\n', '        _mintingStarted = true;\n', '        _minted = false;\n', '        _rate = _price;\n', '        uint256 tokenVal = _val.mul(10 ** uint256(decimals));\n', '        _totalSupply = tokenVal.mul(2);\n', '        _maxMintable = tokenVal;\n', '        _balances[msg.sender] = tokenVal;\n', '        emit Transfer(0x0, msg.sender, tokenVal);\n', '    }\n', '\n', '    function getMinted() public view returns(bool) {\n', '        return _minted;\n', '    }\n', '\n', '    function isOwner(address _addr) public view returns(bool) {\n', '        return _addr == iOwner;\n', '    }\n', '\n', '    function getMintingStatus() public view returns(bool) {\n', '        return _mintingStarted;\n', '    }\n', '\n', '    function getRate() public view returns(uint256) {\n', '        return _rate;\n', '    }\n', '\n', '    function totalMintSupply() public view returns(uint256) {\n', '        return _totalMintSupply;\n', '    }\n', '    \n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _addr) public view returns (uint256) {\n', '        return _balances[_addr];\n', '    }\n', '    \n', '    function allowance(address _from, address _to) public view returns (uint256) {\n', '        return _approvals[_from][_to];\n', '    }\n', '    \n', '    function transfer(address _to, uint _val) public returns (bool) {\n', '        assert(_balances[msg.sender] >= _val && msg.sender != _to);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(_val);\n', '        _balances[_to] = _balances[_to].add(_val);\n', '        emit Transfer(msg.sender, _to, _val);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _val) public returns (bool) {\n', '        assert(_balances[_from] >= _val);\n', '        assert(_approvals[_from][msg.sender] >= _val);\n', '        _approvals[_from][msg.sender] = _approvals[_from][msg.sender].sub(_val);\n', '        _balances[_from] = _balances[_from].sub(_val);\n', '        _balances[_to] = _balances[_to].add(_val);\n', '        emit Transfer(_from, _to, _val);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _to, uint256 _val) public returns (bool) {\n', '        _approvals[msg.sender][_to] = _val;\n', '        emit Approval(msg.sender, _to, _val);\n', '        return true;\n', '    }\n', '    \n', '    function () public mintingStarted payable {\n', '        assert(msg.value > 0);\n', '        uint tokens = msg.value.mul(_rate);\n', '        uint totalToken = _totalMintSupply.add(tokens);\n', '        assert(_maxMintable >= totalToken);\n', '        _balances[msg.sender] = _balances[msg.sender].add(tokens);\n', '        _totalMintSupply = _totalMintSupply.add(tokens);\n', '        iOwner.transfer(msg.value);\n', '        emit Transfer(0x0, msg.sender, tokens);\n', '    }\n', '    \n', '    function moveMintTokens(address _from, address _to, uint256 _value) public iOnlyOwner returns(bool) {\n', '        require(_to != _from);\n', '        require(_balances[_from] >= _value);\n', '        _balances[_from] = _balances[_from].sub(_value);\n', '        _balances[_to] = _balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferMintTokens(address _to, uint256 _value) public iOnlyOwner returns(bool) {\n', '        uint totalToken = _totalMintSupply.add(_value);\n', '        require(_maxMintable >= totalToken);\n', '        _balances[_to] = _balances[_to].add(_value);\n', '        _totalMintSupply = _totalMintSupply.add(_value);\n', '        emit Transfer(0x0, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function releaseMintTokens() public notMinted returns(bool) {\n', '        require(msg.sender == iOwner);\n', '        uint256 releaseAmount = _maxMintable.sub(_totalMintSupply);\n', '        uint256 totalReleased = _totalMintSupply.add(releaseAmount);\n', '        require(_maxMintable >= totalReleased);\n', '        _totalMintSupply = _totalMintSupply.add(releaseAmount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(releaseAmount);\n', '        _minted = true;\n', '        emit Transfer(0x0, msg.sender, releaseAmount);\n', '        emit Release(msg.sender, releaseAmount);\n', '        return true;\n', '    }\n', '\n', '    function changeRate(uint256 _value) public returns (bool) {\n', '        require(msg.sender == iOwner && _value > 0);\n', '        _rate = _value;\n', '        return true;\n', '    }\n', '\n', '    function transferOwnership(address _to) public {\n', '        require(msg.sender == iOwner && _to != msg.sender);  \n', '        address oldOwner = iOwner;\n', '        uint256 balAmount = _balances[oldOwner];\n', '        _balances[_to] = _balances[_to].add(balAmount);\n', '        _balances[oldOwner] = 0;\n', '        iOwner = _to;\n', '        emit Transfer(oldOwner, _to, balAmount);\n', '        emit OwnerTransferred(oldOwner, _to);\n', '    }\n', '    \n', '    event Release(address _addr, uint256 _val);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _from, address indexed _to, uint256 _value);\n', '}']
['pragma solidity ^0.4.24;\n', '///////////////////////////////////////////////////\n', '//  \n', '//  `iCashweb` ICW Token Contract\n', '//\n', '//  Total Tokens: 300,000,000.000000000000000000\n', '//  Name: iCashweb\n', '//  Symbol: ICWeb\n', '//  Decimal Scheme: 18\n', '//  \n', '//  by Nishad Vadgama\n', '///////////////////////////////////////////////////\n', '\n', 'library iMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a / b;\n', '        return c;\n', '    }\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract iCashwebToken {\n', '    \n', '    address public iOwner;\n', '    mapping(address => bool) iOperable;\n', '    bool _mintingStarted;\n', '    bool _minted;\n', '\n', '    modifier notMinted() {\n', '        require(_minted == false);\n', '        _;\n', '    }\n', '\n', '    modifier mintingStarted() {\n', '        require(_mintingStarted == true);\n', '        _;\n', '    }\n', '    \n', '    modifier iOnlyOwner() {\n', '        require(msg.sender == iOwner || iOperable[msg.sender] == true);\n', '        _;\n', '    }\n', '    \n', '    function manageOperable(address _from, bool _value) public returns(bool) {\n', '        require(msg.sender == iOwner);\n', '        iOperable[_from] = _value;\n', '        emit Operable(msg.sender, _from, _value);\n', '        return true;\n', '    }\n', '\n', '    function isOperable(address _addr) public view returns(bool) {\n', '        return iOperable[_addr];\n', '    }\n', '\n', '    function manageMinting(bool _val) public {\n', '        require(msg.sender == iOwner);\n', '        _mintingStarted = _val;\n', '        emit Minting(_val);\n', '    }\n', '\n', '    function destroyContract() public {\n', '        require(msg.sender == iOwner);\n', '        selfdestruct(iOwner);\n', '    }\n', '    \n', '    event Operable(address _owner, address _from, bool _value);\n', '    event Minting(bool _value);\n', '    event OwnerTransferred(address _from, address _to);\n', '}\n', '\n', 'contract iCashweb is iCashwebToken {\n', '    using iMath for uint256;\n', '    \n', '    string public constant name = "iCashweb";\n', '    string public constant symbol = "ICWs";\n', '    uint8 public constant decimals = 18;\n', '    uint256 _totalSupply;\n', '    uint256 _rate;\n', '    uint256 _totalMintSupply;\n', '    uint256 _maxMintable;\n', '    mapping (address => uint256) _balances;\n', '    mapping (address => mapping (address => uint256)) _approvals;\n', '    \n', '    constructor (uint256 _price, uint256 _val) public {\n', '        iOwner = msg.sender;\n', '        _mintingStarted = true;\n', '        _minted = false;\n', '        _rate = _price;\n', '        uint256 tokenVal = _val.mul(10 ** uint256(decimals));\n', '        _totalSupply = tokenVal.mul(2);\n', '        _maxMintable = tokenVal;\n', '        _balances[msg.sender] = tokenVal;\n', '        emit Transfer(0x0, msg.sender, tokenVal);\n', '    }\n', '\n', '    function getMinted() public view returns(bool) {\n', '        return _minted;\n', '    }\n', '\n', '    function isOwner(address _addr) public view returns(bool) {\n', '        return _addr == iOwner;\n', '    }\n', '\n', '    function getMintingStatus() public view returns(bool) {\n', '        return _mintingStarted;\n', '    }\n', '\n', '    function getRate() public view returns(uint256) {\n', '        return _rate;\n', '    }\n', '\n', '    function totalMintSupply() public view returns(uint256) {\n', '        return _totalMintSupply;\n', '    }\n', '    \n', '    function totalSupply() public view returns (uint256) {\n', '        return _totalSupply;\n', '    }\n', '    \n', '    function balanceOf(address _addr) public view returns (uint256) {\n', '        return _balances[_addr];\n', '    }\n', '    \n', '    function allowance(address _from, address _to) public view returns (uint256) {\n', '        return _approvals[_from][_to];\n', '    }\n', '    \n', '    function transfer(address _to, uint _val) public returns (bool) {\n', '        assert(_balances[msg.sender] >= _val && msg.sender != _to);\n', '        _balances[msg.sender] = _balances[msg.sender].sub(_val);\n', '        _balances[_to] = _balances[_to].add(_val);\n', '        emit Transfer(msg.sender, _to, _val);\n', '        return true;\n', '    }\n', '    \n', '    function transferFrom(address _from, address _to, uint _val) public returns (bool) {\n', '        assert(_balances[_from] >= _val);\n', '        assert(_approvals[_from][msg.sender] >= _val);\n', '        _approvals[_from][msg.sender] = _approvals[_from][msg.sender].sub(_val);\n', '        _balances[_from] = _balances[_from].sub(_val);\n', '        _balances[_to] = _balances[_to].add(_val);\n', '        emit Transfer(_from, _to, _val);\n', '        return true;\n', '    }\n', '    \n', '    function approve(address _to, uint256 _val) public returns (bool) {\n', '        _approvals[msg.sender][_to] = _val;\n', '        emit Approval(msg.sender, _to, _val);\n', '        return true;\n', '    }\n', '    \n', '    function () public mintingStarted payable {\n', '        assert(msg.value > 0);\n', '        uint tokens = msg.value.mul(_rate);\n', '        uint totalToken = _totalMintSupply.add(tokens);\n', '        assert(_maxMintable >= totalToken);\n', '        _balances[msg.sender] = _balances[msg.sender].add(tokens);\n', '        _totalMintSupply = _totalMintSupply.add(tokens);\n', '        iOwner.transfer(msg.value);\n', '        emit Transfer(0x0, msg.sender, tokens);\n', '    }\n', '    \n', '    function moveMintTokens(address _from, address _to, uint256 _value) public iOnlyOwner returns(bool) {\n', '        require(_to != _from);\n', '        require(_balances[_from] >= _value);\n', '        _balances[_from] = _balances[_from].sub(_value);\n', '        _balances[_to] = _balances[_to].add(_value);\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '    \n', '    function transferMintTokens(address _to, uint256 _value) public iOnlyOwner returns(bool) {\n', '        uint totalToken = _totalMintSupply.add(_value);\n', '        require(_maxMintable >= totalToken);\n', '        _balances[_to] = _balances[_to].add(_value);\n', '        _totalMintSupply = _totalMintSupply.add(_value);\n', '        emit Transfer(0x0, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function releaseMintTokens() public notMinted returns(bool) {\n', '        require(msg.sender == iOwner);\n', '        uint256 releaseAmount = _maxMintable.sub(_totalMintSupply);\n', '        uint256 totalReleased = _totalMintSupply.add(releaseAmount);\n', '        require(_maxMintable >= totalReleased);\n', '        _totalMintSupply = _totalMintSupply.add(releaseAmount);\n', '        _balances[msg.sender] = _balances[msg.sender].add(releaseAmount);\n', '        _minted = true;\n', '        emit Transfer(0x0, msg.sender, releaseAmount);\n', '        emit Release(msg.sender, releaseAmount);\n', '        return true;\n', '    }\n', '\n', '    function changeRate(uint256 _value) public returns (bool) {\n', '        require(msg.sender == iOwner && _value > 0);\n', '        _rate = _value;\n', '        return true;\n', '    }\n', '\n', '    function transferOwnership(address _to) public {\n', '        require(msg.sender == iOwner && _to != msg.sender);  \n', '        address oldOwner = iOwner;\n', '        uint256 balAmount = _balances[oldOwner];\n', '        _balances[_to] = _balances[_to].add(balAmount);\n', '        _balances[oldOwner] = 0;\n', '        iOwner = _to;\n', '        emit Transfer(oldOwner, _to, balAmount);\n', '        emit OwnerTransferred(oldOwner, _to);\n', '    }\n', '    \n', '    event Release(address _addr, uint256 _val);\n', '    event Transfer(address indexed _from, address indexed _to, uint256 _value);\n', '    event Approval(address indexed _from, address indexed _to, uint256 _value);\n', '}']
