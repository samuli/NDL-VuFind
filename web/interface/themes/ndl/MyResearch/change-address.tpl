<form method="post" action="{$url}/MyResearch/Profile" class="address_form profile_form">
    <h2>{translate text="axiell_request_address_change"}</h2>
    <table class="profileGroup">
        <tr>
            <th>{translate text='Address'}</th>
            <td><input type="text" name="changeAddressLine1" value="{$address}"></input></td>
        </tr>
        <tr>
            <th>{translate text='Zip'}</th>
            <td><input type="text" name="changeAddressZip" value="{$zip}"></input></td>
        </tr>
            <th>
                <input type="hidden" name="email" value="{$email}"></input>
                <input type="hidden" name="name" value="{$name}"></input>
                <input type="hidden" name="library" value="{$library}"></input>
                <input type="hidden" name="oldAddress" value="{$address}"></input>
                <input type="hidden" name="oldZip" value="{$zip}"></input>
                <input type="hidden" name="username" value="{$username}"></input>
                <input class="button buttonFinna left" type="submit" value="{translate text='Save'}" />
            </th>
            <td><td>
        </tr>
    </table>
</form>
<span class="addressChangeDescription">
{translate text="axiell_address_change_description"}
</span>