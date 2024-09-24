class Something
{
    [string]$Name = 'Something'

    Something()
    {
        #default Constructor
    }

    [String] ToString()
    {
        # Typo "class" is intentional
        return ( 'This class is {0}' -f $this.Name)
    }
}
