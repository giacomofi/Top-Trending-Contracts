['pragma solidity ^0.4.19;\n', '\n', 'contract BaseToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BurnToken is BaseToken {\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract AirdropToken is BaseToken {\n', '    uint256 public airAmount;\n', '    uint256 public airBegintime;\n', '    uint256 public airEndtime;\n', '    address public airSender;\n', '    uint32 public airLimitCount;\n', '\n', '    mapping (address => uint32) public airCountOf;\n', '\n', '    event Airdrop(address indexed from, uint32 indexed count, uint256 tokenValue);\n', '\n', '    function airdrop() public payable {\n', '        require(now >= airBegintime && now <= airEndtime);\n', '        require(msg.value == 0);\n', '        if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {\n', '            revert();\n', '        }\n', '        _transfer(airSender, msg.sender, airAmount);\n', '        airCountOf[msg.sender] += 1;\n', '        Airdrop(msg.sender, airCountOf[msg.sender], airAmount);\n', '    }\n', '}\n', '\n', 'contract LockToken is BaseToken {\n', '    struct LockMeta {\n', '        uint256 amount;\n', '        uint256 endtime;\n', '    }\n', '    \n', '    mapping (address => LockMeta) public lockedAddresses;\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(balanceOf[_from] >= _value);\n', '        LockMeta storage meta = lockedAddresses[_from];\n', '        require(now >= meta.endtime || meta.amount <= balanceOf[_from] - _value);\n', '        super._transfer(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'contract CustomToken is BaseToken, BurnToken, AirdropToken, LockToken {\n', '    function CustomToken() public {\n', '        totalSupply = 100000000000000000000000000;\n', '        name = &#39;EthLinkerToken&#39;;\n', '        symbol = &#39;ELT&#39;;\n', '        decimals = 18;\n', '        balanceOf[0x0926a20aca505b82f7cb7864e1246894eac27ea0] = totalSupply;\n', '        Transfer(address(0), 0x0926a20aca505b82f7cb7864e1246894eac27ea0, totalSupply);\n', '\n', '        airAmount = 66000000000000000000;\n', '        airBegintime = 1523095200;\n', '        airEndtime = 1617789600;\n', '        airSender = 0x8888888888888888888888888888888888888888;\n', '        airLimitCount = 1;\n', '\n', '        lockedAddresses[0xf60340e79829061f1ab918ee92c064dbe06ff168] = LockMeta({amount: 10000000000000000000000000, endtime: 1554652800});\n', '        lockedAddresses[0x0b03316fe4949c15b3677d67293d3ed359889aac] = LockMeta({amount: 10000000000000000000000000, endtime: 1586275200});\n', '        lockedAddresses[0x139a911a9086522d84ac54f992a9243e8fedeb95] = LockMeta({amount: 10000000000000000000000000, endtime: 1617811200});\n', '    }\n', '\n', '    function() public payable {\n', '        airdrop();\n', '    }\n', '}']
['pragma solidity ^0.4.19;\n', '\n', 'contract BaseToken {\n', '    string public name;\n', '    string public symbol;\n', '    uint8 public decimals;\n', '    uint256 public totalSupply;\n', '\n', '    mapping (address => uint256) public balanceOf;\n', '    mapping (address => mapping (address => uint256)) public allowance;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(_to != 0x0);\n', '        require(balanceOf[_from] >= _value);\n', '        require(balanceOf[_to] + _value > balanceOf[_to]);\n', '        uint previousBalances = balanceOf[_from] + balanceOf[_to];\n', '        balanceOf[_from] -= _value;\n', '        balanceOf[_to] += _value;\n', '        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);\n', '        Transfer(_from, _to, _value);\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool success) {\n', '        _transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        allowance[_from][msg.sender] -= _value;\n', '        _transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool success) {\n', '        allowance[msg.sender][_spender] = _value;\n', '        Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract BurnToken is BaseToken {\n', '    event Burn(address indexed from, uint256 value);\n', '\n', '    function burn(uint256 _value) public returns (bool success) {\n', '        require(balanceOf[msg.sender] >= _value);\n', '        balanceOf[msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(msg.sender, _value);\n', '        return true;\n', '    }\n', '\n', '    function burnFrom(address _from, uint256 _value) public returns (bool success) {\n', '        require(balanceOf[_from] >= _value);\n', '        require(_value <= allowance[_from][msg.sender]);\n', '        balanceOf[_from] -= _value;\n', '        allowance[_from][msg.sender] -= _value;\n', '        totalSupply -= _value;\n', '        Burn(_from, _value);\n', '        return true;\n', '    }\n', '}\n', '\n', 'contract AirdropToken is BaseToken {\n', '    uint256 public airAmount;\n', '    uint256 public airBegintime;\n', '    uint256 public airEndtime;\n', '    address public airSender;\n', '    uint32 public airLimitCount;\n', '\n', '    mapping (address => uint32) public airCountOf;\n', '\n', '    event Airdrop(address indexed from, uint32 indexed count, uint256 tokenValue);\n', '\n', '    function airdrop() public payable {\n', '        require(now >= airBegintime && now <= airEndtime);\n', '        require(msg.value == 0);\n', '        if (airLimitCount > 0 && airCountOf[msg.sender] >= airLimitCount) {\n', '            revert();\n', '        }\n', '        _transfer(airSender, msg.sender, airAmount);\n', '        airCountOf[msg.sender] += 1;\n', '        Airdrop(msg.sender, airCountOf[msg.sender], airAmount);\n', '    }\n', '}\n', '\n', 'contract LockToken is BaseToken {\n', '    struct LockMeta {\n', '        uint256 amount;\n', '        uint256 endtime;\n', '    }\n', '    \n', '    mapping (address => LockMeta) public lockedAddresses;\n', '\n', '    function _transfer(address _from, address _to, uint _value) internal {\n', '        require(balanceOf[_from] >= _value);\n', '        LockMeta storage meta = lockedAddresses[_from];\n', '        require(now >= meta.endtime || meta.amount <= balanceOf[_from] - _value);\n', '        super._transfer(_from, _to, _value);\n', '    }\n', '}\n', '\n', 'contract CustomToken is BaseToken, BurnToken, AirdropToken, LockToken {\n', '    function CustomToken() public {\n', '        totalSupply = 100000000000000000000000000;\n', "        name = 'EthLinkerToken';\n", "        symbol = 'ELT';\n", '        decimals = 18;\n', '        balanceOf[0x0926a20aca505b82f7cb7864e1246894eac27ea0] = totalSupply;\n', '        Transfer(address(0), 0x0926a20aca505b82f7cb7864e1246894eac27ea0, totalSupply);\n', '\n', '        airAmount = 66000000000000000000;\n', '        airBegintime = 1523095200;\n', '        airEndtime = 1617789600;\n', '        airSender = 0x8888888888888888888888888888888888888888;\n', '        airLimitCount = 1;\n', '\n', '        lockedAddresses[0xf60340e79829061f1ab918ee92c064dbe06ff168] = LockMeta({amount: 10000000000000000000000000, endtime: 1554652800});\n', '        lockedAddresses[0x0b03316fe4949c15b3677d67293d3ed359889aac] = LockMeta({amount: 10000000000000000000000000, endtime: 1586275200});\n', '        lockedAddresses[0x139a911a9086522d84ac54f992a9243e8fedeb95] = LockMeta({amount: 10000000000000000000000000, endtime: 1617811200});\n', '    }\n', '\n', '    function() public payable {\n', '        airdrop();\n', '    }\n', '}']