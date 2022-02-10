['pragma solidity ^0.5.7;\n', '\n', '/* NASH TOKEN FIRST EDITION\n', 'THE NEW WORLD BLOCKCHAIN PROJECT\n', 'CREATED 2019-04-18 BY DAO DRIVER ETHEREUM (c)*/\n', '\n', 'library SafeMath {\n', '    \n', '    function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        return a / b;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns(uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns(uint256 c) {\n', '        c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', 'contract owned {\n', '    address payable internal owner;\n', '    address payable internal newOwner;\n', '    address payable internal found;\n', '    address payable internal feedr;\n', '    \n', '    modifier onlyOwner {\n', '        require(owner == msg.sender);\n', '        _;\n', '    }\n', '\n', '    function changeOwner(address payable _owner) onlyOwner public {\n', '        require(_owner != address(0));\n', '        newOwner = _owner;\n', '    }\n', '\n', '    function confirmOwner() public {\n', '        require(newOwner == msg.sender);\n', '        owner = newOwner;\n', '        delete newOwner;\n', '    }\n', '}\n', '\n', 'contract ERC20Basic {\n', '    modifier onlyPayloadSize(uint size) {\n', '        require(msg.data.length >= size + 4);\n', '        _;\n', '    }\n', '    function totalSupply() public view returns(uint256);\n', '    function balanceOf(address who) public view returns(uint256);\n', '    function transfer(address payable to, uint256 value) public returns(bool);\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '}\n', '\n', 'contract ERC20 is ERC20Basic {\n', '    function allowance(address owner, address spender) public view returns(uint256);\n', '    function transferFrom(address payable from, address payable to, uint256 value) public returns(bool);\n', '    function approve(address spender, uint256 value) public returns(bool);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '}\n', '\n', 'contract TokenBasic is ERC20Basic, owned {\n', '    using SafeMath for uint256;\n', '    mapping(address => uint256) internal balances;\n', '    uint256 internal totalSupply_;\n', '    uint256 internal activeSupply_;\n', '    mapping(uint256 => uint256) public sum_;\n', '    mapping(address => uint256) public pdat_;\n', '    uint256 public pnr_;\n', '\n', '    function totalSupply() public view returns(uint256) {\n', '        return totalSupply_;\n', '    }\n', '\n', '    function activeSupply() public view returns(uint256) {\n', '        return activeSupply_;\n', '    }\n', '\n', '    function transfer(address payable _to, uint256 _value) public onlyPayloadSize(2 * 32) returns(bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        require(_to != found);\n', '        uint256 div1 = 0;\n', '        uint256 div2 = 0;\n', '        if (msg.sender != found) {\n', '            if (pdat_[msg.sender] < pnr_) {\n', '                for (uint256 i = pnr_; i >= pdat_[msg.sender]; i = i.sub(1)) {\n', '                    div1 = div1.add(sum_[i].mul(balances[msg.sender]));\n', '                }\n', '            }\n', '        }\n', '        if (pdat_[_to] < pnr_ && balances[_to] > 0) {\n', '            for (uint256 i = pnr_; i >= pdat_[_to]; i = i.sub(1)) {\n', '                div2 = div2.add(sum_[i].mul(balances[_to]));\n', '            }\n', '        }\n', '        \n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        \n', '        pdat_[_to] = pnr_;\n', '        \n', '        emit Transfer(msg.sender, _to, _value);\n', '        \n', '        if (msg.sender == found) {\n', '            activeSupply_ = activeSupply_.add(_value);\n', '        } else {\n', '            pdat_[msg.sender] = pnr_;\n', '            if (div1 > 0) {\n', '                msg.sender.transfer(div1);\n', '            }\n', '        }\n', '        if (div2 > 0) {\n', '            _to.transfer(div2);\n', '        }\n', '        return true;\n', '    }\n', '\n', '    function balanceOf(address _owner) public view returns(uint256) {\n', '        return balances[_owner];\n', '    }\n', '}\n', '\n', 'contract TokenStandard is ERC20, TokenBasic {\n', '    \n', '    mapping(address => mapping(address => uint256)) internal allowed;\n', '    function transferFrom(address payable _from, address payable _to, uint256 _value) public onlyPayloadSize(3 * 32) returns(bool) {\n', '        require(_to != address(0));\n', '        require(_to != found);\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '        uint256 div1 = 0;\n', '        uint256 div2 = 0;\n', '        if (_from != found) {\n', '            if (pdat_[_from] < pnr_) {\n', '                for (uint256 i = pnr_; i >= pdat_[_from]; i = i.sub(1)) {\n', '                    div1 = div1.add(sum_[i].mul(balances[_from]));\n', '                }\n', '            }\n', '        }\n', '        if (pdat_[_to] < pnr_ && balances[_to] > 0) {\n', '            for (uint256 i = pnr_; i >= pdat_[_to]; i = i.sub(1)) {\n', '                div2 = div2.add(sum_[i].mul(balances[_to]));\n', '            }\n', '        }\n', '        \n', '        balances[_from] = balances[_from].sub(_value);\n', '        balances[_to] = balances[_to].add(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '        \n', '        pdat_[_to] = pnr_;\n', '        \n', '        emit Transfer(_from, _to, _value);\n', '        if (_from == found) {\n', '            activeSupply_ = activeSupply_.add(_value);\n', '        } else {\n', '            pdat_[_from] = pnr_;\n', '            if (div1 > 0) {\n', '                _from.transfer(div1);\n', '            }\n', '        }\n', '        if (div2 > 0) {\n', '            _to.transfer(div2);\n', '        }\n', '        return true;\n', '    }\n', '    function approve(address _spender, uint256 _value) public returns(bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '    function allowance(address _owner, address _spender) public view returns(uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '    function increaseApproval(address _spender, uint _addrdedValue) public returns(bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addrdedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns(bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '}\n', 'contract ANASH is TokenStandard {\n', '    string public constant name = "NASH TOKEN";\n', '    string public constant symbol = "NASH";\n', '    uint8 public constant decimals = 2;\n', '    uint256 internal constant premined = 20000000000;\n', '    function() payable external {\n', '        if (feedr == msg.sender) {\n', '            require(msg.value >= 1);\n', '            sum_[pnr_] = msg.value.div(activeSupply_);\n', '            pnr_ = pnr_.add(1);\n', '        } else {\n', '            require(balances[msg.sender] > 0);\n', '            uint256 div1 = 0;\n', '            uint256 cont = 0;\n', '            if (pdat_[msg.sender] < pnr_) {\n', '                for (uint256 i = pnr_; i >= pdat_[msg.sender]; i = i.sub(1)) {\n', '                    div1 = div1.add(sum_[i].mul(balances[msg.sender]));\n', '                    cont = cont.add(1);\n', '                    if(cont > 80){break;}\n', '                }\n', '            }\n', '            pdat_[msg.sender] = pnr_;\n', '            div1 = div1.add(msg.value);\n', '            if (div1 > 0) {\n', '                msg.sender.transfer(div1);\n', '            }\n', '        }\n', '    }\n', '    constructor() public {\n', '        pnr_ = 1;\n', '        owner = msg.sender;\n', '        found = 0xfB538A7365d47183692E1866fC0b32308F15BAFD;\n', '        feedr = 0xCebaa747868135CC4a0d9A4f982849161f3a4CE7;\n', '        totalSupply_ = premined;\n', '        activeSupply_ = 0;\n', '        balances[found] = balances[found].add(premined);\n', '        emit Transfer(address(0), found, premined);\n', '    }\n', '}']