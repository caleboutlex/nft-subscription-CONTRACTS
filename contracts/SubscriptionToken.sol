// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.7.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./SubscriptionBase.sol";

contract SubscriptionToken is SubscriptionBase, ERC1155("") {

    /* ========== EVENTS ========== */
    event SubMinted(uint SubID, address Owner);
    
    /* ========== VIEWS ========== */
    function isOwnerOf(address _account, uint256 _subId)
        public
        view
        returns (bool)
    {
        return balanceOf(_account, _subId) == 1;
    }

    /* ========== OWNER MUTATIVE FUNCTION ========== */
    function setURI(string memory _newuri) external onlyOwner {
        _setURI(_newuri);
    }

    function buySubscription(address _owner) external payable returns (uint256) {
        require(
            msg.value == 0.1 ether, 
            'You must send 0.1 ETH to this contract to sub'
            );

        Subscription memory _sub = Subscription({
            startTime: uint64(block.timestamp), 
            endTime: uint64(block.timestamp + subscriptionTime)
        });

        subscriptions.push(_sub);
        uint256 newSubID = subscriptions.length - 1;

        _mint(_owner, newSubID, 1, "");

        emit SubMinted(newSubID, _owner);

        return newSubID; 
    }

    function getSubscription(uint256 _id)
        external
        view
        returns (
            uint256 id,
            bool expired,
            uint256 start,
            uint256 end,
            uint256 currentTime
        )
    {
        Subscription storage sub = subscriptions[_id];

        id = _id;
        expired = (sub.endTime <= block.timestamp);
        start = sub.startTime;
        end = sub.endTime;
        currentTime = block.timestamp; 
    }

}