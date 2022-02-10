['pragma solidity ^0.4.18;\n', '// US gross value-weighted daily stock return w/o dividends\n', '// 0.10251 ETH balance implies a 1.0251 gross return, 2.51% net return\n', '// pulled using closing prices around 4:15 PM EST \n', 'contract useqgretOracle{\n', '    \n', '    address private owner;\n', '\n', '    function useqgretOracle() \n', '        payable \n', '    {\n', '        owner = msg.sender;\n', '    }\n', '    \n', '    function updateUSeqgret() \n', '        payable \n', '        onlyOwner \n', '    {\n', '        owner.transfer(this.balance-msg.value);\n', '    }\n', '    \n', '    modifier \n', '        onlyOwner \n', '    {\n', '        require(msg.sender == owner);\n', '        _;\n', '    }\n', '\n', '}']