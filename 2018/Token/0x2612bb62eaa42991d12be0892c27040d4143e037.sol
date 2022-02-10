['pragma solidity ^0.4.24;\n', '\n', 'contract ToknTalkToken {\n', '\n', '    event Transfer(address indexed from, address indexed to, uint amount);\n', '    event Approval(address indexed owner, address indexed spender, uint amount);\n', '\n', '    uint private constant MAX_UINT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    address public mintSigner = msg.sender;\n', '    string public constant name = "tokntalk.club";\n', '    string public constant symbol = "TTT";\n', '    uint public constant decimals = 0;\n', '    uint public totalSupply = 0;\n', '    mapping (address => uint) public balanceOf;\n', '    mapping (address => mapping (address => uint)) public allowance;\n', '    mapping (address => uint) public mintedBy;\n', '\n', '    function transfer(address to, uint amount) external returns (bool) {\n', '        require(to != address(this));\n', '        require(to != 0);\n', '        uint balanceOfMsgSender = balanceOf[msg.sender];\n', '        require(balanceOfMsgSender >= amount);\n', '        balanceOf[msg.sender] = balanceOfMsgSender - amount;\n', '        balanceOf[to] += amount;\n', '        emit Transfer(msg.sender, to, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint amount) external returns (bool) {\n', '        require(to != address(this));\n', '        require(to != 0);\n', '        uint allowanceMsgSender = allowance[from][msg.sender];\n', '        require(allowanceMsgSender >= amount);\n', '        if (allowanceMsgSender != MAX_UINT) {\n', '            allowance[from][msg.sender] = allowanceMsgSender - amount;\n', '        }\n', '        uint balanceOfFrom = balanceOf[from];\n', '        require(balanceOfFrom >= amount);\n', '        balanceOf[from] = balanceOfFrom - amount;\n', '        balanceOf[to] += amount;\n', '        emit Transfer(from, to, amount);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint amount) external returns (bool) {\n', '        allowance[msg.sender][spender] = amount;\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function mintUsingSignature(uint max, uint8 v, bytes32 r, bytes32 s) external {\n', '        bytes memory maxString = toString(max);\n', '        bytes memory messageLengthString = toString(124 + maxString.length);\n', '        bytes32 hash = keccak256(abi.encodePacked(\n', '            "\\x19Ethereum Signed Message:\\n",\n', '            messageLengthString,\n', '            "I approve address 0x",\n', '            toHexString(msg.sender),\n', '            " to mint token 0x",\n', '            toHexString(this),\n', '            " up to ",\n', '            maxString\n', '        ));\n', '        require(ecrecover(hash, v, r, s) == mintSigner);\n', '        uint mintedByMsgSender = mintedBy[msg.sender];\n', '        require(max > mintedByMsgSender);\n', '        mintedBy[msg.sender] = max;\n', '        balanceOf[msg.sender] += max - mintedByMsgSender;\n', '        emit Transfer(0, msg.sender, max - mintedByMsgSender);\n', '    }\n', '\n', '    function toString(uint value) private pure returns (bytes) {\n', '        uint tmp = value;\n', '        uint lengthOfValue;\n', '        do {\n', '            lengthOfValue++;\n', '            tmp /= 10;\n', '        } while (tmp != 0);\n', '        bytes memory valueString = new bytes(lengthOfValue);\n', '        while (lengthOfValue != 0) {\n', '            valueString[--lengthOfValue] = bytes1(48 + value % 10);\n', '            value /= 10;\n', '        }\n', '        return valueString;\n', '    }\n', '\n', '    function toHexString(address addr) private pure returns (bytes) {\n', '        uint addrUint = uint(addr);\n', '        uint lengthOfAddr = 40;\n', '        bytes memory addrString = new bytes(lengthOfAddr);\n', '        while (addrUint != 0) {\n', '            addrString[--lengthOfAddr] = bytes1((addrUint % 16 < 10 ? 0x30 : 0x57) + addrUint % 16);\n', '            addrUint /= 16;\n', '        }\n', '        return addrString;\n', '    }\n', '\n', '    function setMintSigner(address newMintSigner) external {\n', '        require(msg.sender == mintSigner);\n', '        mintSigner = newMintSigner;\n', '    }\n', '}']
['pragma solidity ^0.4.24;\n', '\n', 'contract ToknTalkToken {\n', '\n', '    event Transfer(address indexed from, address indexed to, uint amount);\n', '    event Approval(address indexed owner, address indexed spender, uint amount);\n', '\n', '    uint private constant MAX_UINT = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;\n', '\n', '    address public mintSigner = msg.sender;\n', '    string public constant name = "tokntalk.club";\n', '    string public constant symbol = "TTT";\n', '    uint public constant decimals = 0;\n', '    uint public totalSupply = 0;\n', '    mapping (address => uint) public balanceOf;\n', '    mapping (address => mapping (address => uint)) public allowance;\n', '    mapping (address => uint) public mintedBy;\n', '\n', '    function transfer(address to, uint amount) external returns (bool) {\n', '        require(to != address(this));\n', '        require(to != 0);\n', '        uint balanceOfMsgSender = balanceOf[msg.sender];\n', '        require(balanceOfMsgSender >= amount);\n', '        balanceOf[msg.sender] = balanceOfMsgSender - amount;\n', '        balanceOf[to] += amount;\n', '        emit Transfer(msg.sender, to, amount);\n', '        return true;\n', '    }\n', '\n', '    function transferFrom(address from, address to, uint amount) external returns (bool) {\n', '        require(to != address(this));\n', '        require(to != 0);\n', '        uint allowanceMsgSender = allowance[from][msg.sender];\n', '        require(allowanceMsgSender >= amount);\n', '        if (allowanceMsgSender != MAX_UINT) {\n', '            allowance[from][msg.sender] = allowanceMsgSender - amount;\n', '        }\n', '        uint balanceOfFrom = balanceOf[from];\n', '        require(balanceOfFrom >= amount);\n', '        balanceOf[from] = balanceOfFrom - amount;\n', '        balanceOf[to] += amount;\n', '        emit Transfer(from, to, amount);\n', '        return true;\n', '    }\n', '\n', '    function approve(address spender, uint amount) external returns (bool) {\n', '        allowance[msg.sender][spender] = amount;\n', '        emit Approval(msg.sender, spender, amount);\n', '        return true;\n', '    }\n', '\n', '    function mintUsingSignature(uint max, uint8 v, bytes32 r, bytes32 s) external {\n', '        bytes memory maxString = toString(max);\n', '        bytes memory messageLengthString = toString(124 + maxString.length);\n', '        bytes32 hash = keccak256(abi.encodePacked(\n', '            "\\x19Ethereum Signed Message:\\n",\n', '            messageLengthString,\n', '            "I approve address 0x",\n', '            toHexString(msg.sender),\n', '            " to mint token 0x",\n', '            toHexString(this),\n', '            " up to ",\n', '            maxString\n', '        ));\n', '        require(ecrecover(hash, v, r, s) == mintSigner);\n', '        uint mintedByMsgSender = mintedBy[msg.sender];\n', '        require(max > mintedByMsgSender);\n', '        mintedBy[msg.sender] = max;\n', '        balanceOf[msg.sender] += max - mintedByMsgSender;\n', '        emit Transfer(0, msg.sender, max - mintedByMsgSender);\n', '    }\n', '\n', '    function toString(uint value) private pure returns (bytes) {\n', '        uint tmp = value;\n', '        uint lengthOfValue;\n', '        do {\n', '            lengthOfValue++;\n', '            tmp /= 10;\n', '        } while (tmp != 0);\n', '        bytes memory valueString = new bytes(lengthOfValue);\n', '        while (lengthOfValue != 0) {\n', '            valueString[--lengthOfValue] = bytes1(48 + value % 10);\n', '            value /= 10;\n', '        }\n', '        return valueString;\n', '    }\n', '\n', '    function toHexString(address addr) private pure returns (bytes) {\n', '        uint addrUint = uint(addr);\n', '        uint lengthOfAddr = 40;\n', '        bytes memory addrString = new bytes(lengthOfAddr);\n', '        while (addrUint != 0) {\n', '            addrString[--lengthOfAddr] = bytes1((addrUint % 16 < 10 ? 0x30 : 0x57) + addrUint % 16);\n', '            addrUint /= 16;\n', '        }\n', '        return addrString;\n', '    }\n', '\n', '    function setMintSigner(address newMintSigner) external {\n', '        require(msg.sender == mintSigner);\n', '        mintSigner = newMintSigner;\n', '    }\n', '}']