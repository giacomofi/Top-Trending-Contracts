['pragma solidity ^0.4.24;\n', '\n', '/*\n', '\n', '    Copyright 2018, Angelo A. M. & Vicent Nos & Mireia Puig\n', '\n', '    This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '    This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '    You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '*/\n', '\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', '        // assert(a == b * c + a % b); // There is no case in which this doesn&#39;t hold\n', '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '//////////////////////////////////////////////////////////////\n', '//                                                          //\n', '//                 ESSENTIA erc20 & Genesis                 //\n', '//                   https://essentia.one                   //\n', '//                                                          //\n', '//////////////////////////////////////////////////////////////\n', '\n', '\n', '\n', 'contract ESSENTIA_ERC20 is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '    mapping (address => uint256) public balances;\n', '\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '\n', '    // Public variables for the ESSENTIA ERC20 ESS token contract\n', '    string public constant standard = "ESSENTIA erc20 and Genesis";\n', '    uint256 public constant decimals = 18;   // hardcoded to be a constant\n', '    string public name = "ESSENTIA";\n', '    string public symbol = "ESS";\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', 'interface tokenRecipient {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ;\n', '}\n', '\n', '\n', '//\n', '// This creates and adds two genesis pools of ESS tokens to the balance of the A and B ETH addresses\n', '// The A/B ESS Genesis pools are 35/65 of the A+B total ESS Token supply. Integer rounded\n', '//\n', '\n', '\n', 'contract ESSENTIA is ESSENTIA_ERC20 {\n', '\n', '\n', '        address public A;\n', '        address public B;\n', '\n', '\n', '    constructor (\n', '\n', '        ) public {\n', '\n', '        A = 0x9cDc027edFD6D4fa1dbe4D0Fa75B9D67f1f6c69D;\n', '        B = 0x9cDc027edFD6D4fa1dbe4D0Fa75B9D67f1f6c69D;\n', '\n', '\n', '        balances[A]=balances[A].add(614359681*(uint256(10)**decimals));\n', '        balances[B]=balances[B].add(1140953692*(uint256(10)**decimals));\n', '\n', '        totalSupply=balances[A]+balances[B];\n', '\n', '\n', '    }\n', '\n', '}']
['pragma solidity ^0.4.24;\n', '\n', '/*\n', '\n', '    Copyright 2018, Angelo A. M. & Vicent Nos & Mireia Puig\n', '\n', '    This program is free software: you can redistribute it and/or modify\n', '    it under the terms of the GNU General Public License as published by\n', '    the Free Software Foundation, either version 3 of the License, or\n', '    (at your option) any later version.\n', '\n', '    This program is distributed in the hope that it will be useful,\n', '    but WITHOUT ANY WARRANTY; without even the implied warranty of\n', '    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n', '    GNU General Public License for more details.\n', '\n', '    You should have received a copy of the GNU General Public License\n', '    along with this program.  If not, see <http://www.gnu.org/licenses/>.\n', '\n', '*/\n', '\n', '\n', '\n', 'library SafeMath {\n', '    function mul(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        if (a == 0) {\n', '            return 0;\n', '        }\n', '        uint256 c = a * b;\n', '        assert(c / a == b);\n', '        return c;\n', '    }\n', '\n', '    function div(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        // assert(b > 0); // Solidity automatically throws when dividing by 0\n', '        uint256 c = a / b;\n', "        // assert(a == b * c + a % b); // There is no case in which this doesn't hold\n", '        return c;\n', '    }\n', '\n', '    function sub(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        assert(b <= a);\n', '        return a - b;\n', '    }\n', '\n', '    function add(uint256 a, uint256 b) internal pure returns (uint256) {\n', '        uint256 c = a + b;\n', '        assert(c >= a);\n', '        return c;\n', '    }\n', '}\n', '\n', '\n', '\n', 'contract Ownable {\n', '\n', '    address public owner;\n', '\n', '    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);\n', '\n', '    constructor() internal {\n', '        owner = msg.sender;\n', '    }\n', '\n', '    modifier onlyOwner() {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '    function transferOwnership(address newOwner) public onlyOwner {\n', '        require(newOwner != address(0));\n', '        emit OwnershipTransferred(owner, newOwner);\n', '        owner = newOwner;\n', '    }\n', '}\n', '\n', '\n', '\n', '//////////////////////////////////////////////////////////////\n', '//                                                          //\n', '//                 ESSENTIA erc20 & Genesis                 //\n', '//                   https://essentia.one                   //\n', '//                                                          //\n', '//////////////////////////////////////////////////////////////\n', '\n', '\n', '\n', 'contract ESSENTIA_ERC20 is Ownable {\n', '\n', '    using SafeMath for uint256;\n', '\n', '\n', '    mapping (address => uint256) public balances;\n', '\n', '\n', '    mapping (address => mapping (address => uint256)) internal allowed;\n', '\n', '\n', '\n', '    // Public variables for the ESSENTIA ERC20 ESS token contract\n', '    string public constant standard = "ESSENTIA erc20 and Genesis";\n', '    uint256 public constant decimals = 18;   // hardcoded to be a constant\n', '    string public name = "ESSENTIA";\n', '    string public symbol = "ESS";\n', '    uint256 public totalSupply;\n', '\n', '    event Transfer(address indexed from, address indexed to, uint256 value);\n', '    event Approval(address indexed owner, address indexed spender, uint256 value);\n', '\n', '\n', '\n', '    function balanceOf(address _owner) public view returns (uint256) {\n', '        return balances[_owner];\n', '    }\n', '\n', '    function transfer(address _to, uint256 _value) public returns (bool) {\n', '\n', '        require(_to != address(0));\n', '        require(_value <= balances[msg.sender]);\n', '        // SafeMath.sub will throw if there is not enough balance.\n', '        balances[msg.sender] = balances[msg.sender].sub(_value);\n', '\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '        emit Transfer(msg.sender, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {\n', '        require(_to != address(0));\n', '        require(_value <= balances[_from]);\n', '        require(_value <= allowed[_from][msg.sender]);\n', '\n', '        balances[_from] = balances[_from].sub(_value);\n', '        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);\n', '\n', '\n', '        balances[_to] = balances[_to].add(_value);\n', '\n', '\n', '        emit Transfer(_from, _to, _value);\n', '        return true;\n', '    }\n', '\n', '    function approve(address _spender, uint256 _value) public returns (bool) {\n', '        allowed[msg.sender][_spender] = _value;\n', '        emit Approval(msg.sender, _spender, _value);\n', '        return true;\n', '    }\n', '\n', '    function allowance(address _owner, address _spender) public view returns (uint256) {\n', '        return allowed[_owner][_spender];\n', '    }\n', '\n', '    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {\n', '        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {\n', '        uint oldValue = allowed[msg.sender][_spender];\n', '        if (_subtractedValue > oldValue) {\n', '            allowed[msg.sender][_spender] = 0;\n', '        } else {\n', '            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);\n', '        }\n', '        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);\n', '        return true;\n', '    }\n', '\n', '    /* Approve and then communicate the approved contract in a single tx */\n', '    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {\n', '        tokenRecipient spender = tokenRecipient(_spender);\n', '\n', '        if (approve(_spender, _value)) {\n', '            spender.receiveApproval(msg.sender, _value, this, _extraData);\n', '            return true;\n', '        }\n', '    }\n', '}\n', '\n', '\n', '\n', 'interface tokenRecipient {\n', '    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external ;\n', '}\n', '\n', '\n', '//\n', '// This creates and adds two genesis pools of ESS tokens to the balance of the A and B ETH addresses\n', '// The A/B ESS Genesis pools are 35/65 of the A+B total ESS Token supply. Integer rounded\n', '//\n', '\n', '\n', 'contract ESSENTIA is ESSENTIA_ERC20 {\n', '\n', '\n', '        address public A;\n', '        address public B;\n', '\n', '\n', '    constructor (\n', '\n', '        ) public {\n', '\n', '        A = 0x9cDc027edFD6D4fa1dbe4D0Fa75B9D67f1f6c69D;\n', '        B = 0x9cDc027edFD6D4fa1dbe4D0Fa75B9D67f1f6c69D;\n', '\n', '\n', '        balances[A]=balances[A].add(614359681*(uint256(10)**decimals));\n', '        balances[B]=balances[B].add(1140953692*(uint256(10)**decimals));\n', '\n', '        totalSupply=balances[A]+balances[B];\n', '\n', '\n', '    }\n', '\n', '}']
