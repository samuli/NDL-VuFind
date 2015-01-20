<form method="post" action="{$url}/MyResearch/Profile" class="address_form profile_form">
    <table class="profileGroup">
        <tr>
            <th>{translate text='Address'}</th>
            <td><input type="text" name="changeAddressLine1" value="{$address1}"></input></td>
        </tr>
        <tr>
            <th>{translate text='Zip'}</th>
            <td><input type="text" name="changeAddressZip" value="{$zip}"></input></td>
        </tr>
        <tr>
            <th>
                <input class="button buttonFinna left" type="submit" value="{translate text='Send'}" />
            </th>
            <td><td>
        </tr>
    </table>
</form>
<span class="addressChangeDescription">
  {translate text="request_change_description"}
</span>